namespace :build do
  desc "Builds the arachnid database"
  task :spiders => :environment do
    BuildHelper::say "Building spider database from external sources."
    BuildHelper::build_spiders
  end
end
