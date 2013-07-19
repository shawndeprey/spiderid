# encoding: utf-8
require 'net/http'
module BuildHelper

	def self.build_spiders
		# Step 1: Build out our families and genus
    BuildHelper::pull_genera_and_family

    # Step 2: Build all of our species scientific names by batching through genus and calling our source
    BuildHelper::pull_species_scientific_names

    # Step 3: Build all known spiders from the United States
    BuildHelper::pull_north_american_species
  end



  # HIT SOURCE DATA

  def self.pull_genera_and_family
    html = Net::HTTP.get URI(ApplicationHelper::GENERA_AND_FAMILY)
    BuildHelper::build_genera_and_family(html) unless html.blank?
    BuildHelper::say "Resource at #{ApplicationHelper::GENERA_AND_FAMILY} returned null" if html.blank?
  end

  def self.pull_species_scientific_names
    Genera.where("id >= 0").find_in_batches do |genus|
      BuildHelper::say "Queuing generas up to \e[36m#{genus.last.id}/#{Genera.count}\e[0m..."
      genus.each do |genera|
        SpeciesWorker.perform_async(genera.name)
      end
    end
  end

  def self.pull_north_american_species
    TextHelper::state_codes.each do |state|
      BuildHelper::say "Queuing \e[36m#{state.first}\e[0m for import from insect id..."
      NorthAmericaWorker.perform_async(state.first)
    end
  end



  # BUILD FROM HTML DATA

  def self.build_genera_and_family(html)
  	BuildHelper::say "Building Families and Genus from #{ApplicationHelper::GENERA_AND_FAMILY}"
  	# First we scan our html and grab then families and genus
  	matches = html.scan(/<i>(.+)<\/i>, (.+)<br>/i)

  	# Next, we cycle through the families and genus from the source and add them to our DB if we don't have them
  	# If we do have them, we update our data.
    n = 0
    matches.each do |genera_family|
    	# We should only update our data if the data from the source is OK. Lets check that!
    	if genera_family.length == 2 && !genera_family[0].blank? && !genera_family[1].blank?
        n += 1
        BuildHelper::say "Imported \e[36m#{n}/#{matches.length}\e[0m genus..." if n % 100 == 0
    		# At this point we know we have a good family. Lets create or update existing models
        BuildHelper::attach_family_and_genera!(genera_family[1], genera_family[0])
    		
    	end
    end unless matches.blank?
    BuildHelper::say "Finished building Families and Genus"
  end

  def self.build_species_scientific_names(genera_name, html)
    # This function builds out all of the species for a particular genera
    # First we must build our species match based on our source data layous
    genera = Genera.find_by_name(genera_name)
    unless genera.blank?
      matches = html.scan(/<li>species: .+<em>#{genera.name} (.+)<\/em>/i)
      BuildHelper::say "Building species for the \e[36m#{genera.name}\e[0m genera..."

      # Next we cycle through our matches, only dealing with those that aren't blank
      matches.each do |scientific_species_name|
        if scientific_species_name.length > 0 && !scientific_species_name[0].blank?
          # If we have a good match, then either add or update it
          BuildHelper::attach_species_genera_and_family!(genera, scientific_species_name[0])
        end
      end unless matches.blank?
    end
  end

  def self.build_north_american_species(html, state)
    BuildHelper::say "Building species from \e[36m#{state}\e[0m."
    # We must perform a rescue in this case because a single worker needs to handle a great number of spiders.
    begin
      species_source_list = html.scan(/<a href="(.+)"><img.+width="170".+><\/a>/i)
      species_source_list.each do |species_source|
        if species_source.length > 0 && !species_source[0].blank?
          # First we need to pull the source document
          html = Net::HTTP.get URI("#{ApplicationHelper::INSECT_ID}#{species_source[0].gsub(/\s/,'-')}")

          # Next we scan our source for Common Name, Genera, and Species Name. In that order.
          family_name = html.scan(/\sFamily:\s<span class="textItalics">(.+)<\/span>/i).first unless html.blank?
          names = html.scan(/<h1><span class="textDkBlue">(.+)<\/span>.+<span class="textDkGray">\((.+)\&nbsp\;(.+)\)<\/span><\/h1>/i).first unless html.blank?
          if !names.blank? && !family_name.blank? && names.length == 3 && !names[0].blank? && !names[1].blank? && !names[2].blank? && !family_name[0].blank?

            # Build out genera and family
            BuildHelper::attach_family_and_genera!(family_name[0], names[1])
            genera = Genera.find_by_name(names[1])
            unless genera.blank?

              # New we build out the species
              BuildHelper::attach_species_genera_and_family!(genera, names[2])
              species = Species.find_by_scientific_name("#{genera.name} #{names[2]}")
              unless species.blank?

                # By this point, we can be certain we have the correct species. Lets add a common name to it.
                BuildHelper::say "Updating Species \e[36m#{species.scientific_name}\e[0m with common name \e[36m#{names[0]}\e[0m."
                species.common_name = names[0]

                # Build other_names
                other_names = html.scan(/<span class="textBold">Other Names:<\/span>(.+)<br/i).first
                species.other_names = other_names[0].gsub(/^\s/, '') unless other_names.blank?

                # Build locations_found
                locations_found = html.scan(/<p><span class="textBold">North American Reach.+:<\/span>(.+)<\/p>/i).first
                species.locations_found = locations_found[0].gsub(/^\s/, '').gsub(/\;/, ',') unless locations_found.blank?

                # Build adult_size
                adult_size = html.scan(/<span class="textBold">Adult Size.+:<\/span>.+\n(.+)\n(.+)<span/i).first
                species.adult_size = "#{adult_size[0]} #{adult_size[1]}".gsub(/^\s|^\s\s|\s$/i, '') unless adult_size.blank?

                # Build characteristics
                characteristics = html.scan(/<p><span class="textBold">Identifying Colors:<\/span>(.+)<\/p>/i).first
                species.characteristics = BuildHelper::merge_csv_lists(species.characteristics, characteristics[0].gsub(/^\s/, '').gsub(/\;/, ',')) unless characteristics.blank?

                # Build description
                description = html.scan(/<p><span class="textBold">General Description:<\/span>(.+)<\/p>/i).first
                species.description = description[0].gsub(/^\s/, '') unless description.blank?

                # Build overview
                overview = html.scan(/<span class="textDkGray textMedium1"><p>([A-Za-z0-9\s\.\,\<\>\:\'\"\?\[\]\{\}\!\~\`\!\@\#\$\%\^\&\*\(\)\-\_\=\+\;]+)<\/p>/im).first
                species.overview = overview[0].gsub(/^\s|\r|\n|\t|[\s]+$/, '').gsub(/<br>/i, "\n") unless overview.blank?

                species.save

              end
            end
          end
        end
      end
    rescue Exception => e
      BuildHelper::say "There was an exception building a spider from \e[36m#{state}\e[0m: #{e}"
    end
  end



  # General Use Functions
  def self.attach_species_genera_and_family!(genera, species_name)
    species = Species.find_by_scientific_name("#{genera.name} #{species_name}") || Species.new(:scientific_name => "#{genera.name} #{species_name}")
    # By this function we assume genera already has a family
    # Next, we add the species to the genera and family to species
    species.family = genera.family
    genera.species << species

    # Finally, we save our genera and species models
    species.save
    species.family.save
    genera.save
  end

  def self.attach_family_and_genera!(family_name, genera_name)
    # Finally we add the genera to our family if the genera does not already exist on our family
    family = Family.find_by_name(family_name) || Family.new(:name => family_name)
    genera = Genera.find_by_name(genera_name) || Genera.new(:name => genera_name)

    family.generas << genera if family.generas.index{|g| g.name == genera.name}.blank?
    genera.save
    family.save
  end

  def self.merge_csv_lists(original, new_list)
    return original if new_list.blank?
    return new_list if original.blank?
    old_list = original.gsub(/\s/,'').split(',')
    new_list.gsub(/\s/,'').split(',').each{ |val| old_list.push( val ) unless( old_list.include?(val) ) }
    return old_list.uniq.join(", ")
  end

  def self.say(text)
  	puts "\e[33mBUILDER: \e[0m#{text}" unless Rails.env.test?
  end

end
