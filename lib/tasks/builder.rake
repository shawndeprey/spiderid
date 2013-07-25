namespace :build do
	namespace :spider do
		desc "Builds arachnid genera and family"
	  task :genera_and_family => :environment do
	    BuildHelper::pull_genera_and_family
	  end

	  desc "Builds arachnid scientific species from american history museum"
	  task :species_scientific_names => :environment do
	    BuildHelper::pull_species_scientific_names
	  end

	  desc "Builds arachnid data from insect id"
	  task :north_america => :environment do
	    BuildHelper::pull_north_american_species
	  end

	  desc "Builds arachnid data from insect id"
	  task :europe => :environment do
	    BuildHelper::pull_european_species
	  end

	  desc "Builds the arachnid database"
	  task :all => :environment do
	  	BuildHelper::say "This command has been removed temporarily. Please run the build in the proper order manually..."
	    # BuildHelper::say "Building full spider database from external sources."
	    # BuildHelper::build_spiders
	  end
	end

	task :delete_index => :environment do
  	BuildHelper::say "Deleting species index..."
  	Tire::Index.new(Species.index_name).delete 
  end
  # Create Index With
  # rake environment tire:import:model CLASS='Species'

=begin
    	create({ :settings => {
	    		:species => Species.settings
	    	},
	    	:mappings => {
		      :species => Species.mapping
		    }
		  })
=end
=begin
	desc "Tell Tire to roll through all Species and index them. Also tell tire to refresh the search index."
  task :search_index => :environment do
  	BuildHelper::say "Deleting species index..."
  	Tire::Index.new(Species.index_name).delete 

    Tire.index Species.index_name do
    	puts "Deleting old species index..."
    	delete
    	create
      Species.where("id >= 0").find_in_batches do |species|
        puts "Importing group, Last Name: #{species.last.scientific_name}, Last ID: #{species.last.id}"
        import species
      end
      refresh
    end

  end
=end

end
