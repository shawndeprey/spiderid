# encoding: utf-8
require 'net/http'
module BuildHelper

	def self.build_spiders
		# Step 1: Build out our families and species
    html = Net::HTTP.get URI(ApplicationHelper::GENERA_AND_FAMILY)
	  BuildHelper::build_genera_and_family(html) unless html.blank?
	  BuildHelper::say "Resource at #{ApplicationHelper::GENERA_AND_FAMILY} returned null" if html.blank?
  end

  def self.build_genera_and_family(html)
  	BuildHelper::say "Building Families and Genus from #{ApplicationHelper::GENERA_AND_FAMILY}"
  	BuildHelper::say "This may take a few minutes..."
  	# First we scan our html and grab then families and genus
  	matches = html.scan(/<i>(.+)<\/i>, (.+)<br>/i)

  	# Next, we cycle through the families and genus from the source and add them to our DB if we don't have them
  	# If we do have them, we update our data.
    matches.each do |genera_family|
    	# We should only update our data if the data from the source is OK. Lets check that!
    	if genera_family.length == 2 && !genera_family[0].blank? && !genera_family[1].blank?

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

  def self.say(text)
  	puts "\e[33mBUILDER: \e[0m#{text}" unless Rails.env.test?
  end

end
