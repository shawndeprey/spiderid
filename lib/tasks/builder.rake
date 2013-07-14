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

	desc "Tell Tire to roll through all Species and index them. Also tell tire to refresh the search index."
  task :search_index => :environment do
    puts "Deleting old species index"
    ['species'].each do |index_name|
      index = Tire::Index.new index_name
      index.delete
    end
    puts "Rolling through all Species and indexing them for search."
    start = Time.now
    Tire.index Species.index_name do
      Species.where("id >= 0").find_in_batches do |species|
        puts "Importing group, Last Name: #{species.last.scientific_name}, Last ID: #{species.last.id}"
        import species
      end
      refresh
    end
    puts "Built species search index in #{Time.now - start} seconds"
  end
end
