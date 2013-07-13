namespace :build do
	namespace :spider do
		desc "Builds the arachnid database"
	  task :genera_and_family => :environment do
	    BuildHelper::pull_genera_and_family
	  end

	  desc "Builds the arachnid database"
	  task :species_scientific_names => :environment do
	    BuildHelper::pull_species_scientific_names
	  end

	  desc "Builds the arachnid database"
	  task :all => :environment do
	  	BuildHelper::say "This command has been removed temporarily. Please run the build in the proper order manually..."
	    # BuildHelper::say "Building full spider database from external sources."
	    # BuildHelper::build_spiders
	  end
	end
end
