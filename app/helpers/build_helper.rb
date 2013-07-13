# encoding: utf-8
require 'net/http'
module BuildHelper

	def self.build_spiders
		# Step 1: Build out our families and genus
    BuildHelper::pull_genera_and_family

    # Step 2: Build all of our species scientific names by batching through genus and calling our source
    BuildHelper::pull_species_scientific_names
  end



  # HIT SOURCE DATA

  def self.pull_genera_and_family
    html = Net::HTTP.get URI(ApplicationHelper::GENERA_AND_FAMILY)
    BuildHelper::build_genera_and_family(html) unless html.blank?
    BuildHelper::say "Resource at #{ApplicationHelper::GENERA_AND_FAMILY} returned null" if html.blank?
  end

  def self.pull_species_scientific_names
    Genera.where("id >= 0").find_in_batches do |genus|
      #genus.each do |genera|
      #  SpeciesWorker.perform_async(genera.name)
      #end
      SpeciesWorker.perform_async(genus.first.name)
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
    		family = Family.find_by_name(genera_family[1]) || Family.new
    		genera = Genera.find_by_name(genera_family[0]) || Genera.new

    		# Next we ensure the name data makes it onto our models
    		family.name = genera_family[1]
    		genera.name = genera_family[0]

    		# Finally we add the genera to our family if the genera does not already exist on our family
    		family.generas << genera if family.generas.index{|g| g.name == genera.name}.blank?

    		genera.save
    		family.save
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
          species = Species.find_by_scientific_name(scientific_species_name[0]) || Species.new

          # Add our source data to our model
          species.scientific_name = scientific_species_name[0]

          # Next, we add the species to the genera and family to species
          species.family = genera.family
          genera.species << species

          # Finally, we save our genera and species models
          species.save
          species.family.save
          genera.save
        end
      end unless matches.blank?
    end
  end

  def self.say(text)
  	puts "\e[33mBUILDER: \e[0m#{text}" unless Rails.env.test?
  end

end
