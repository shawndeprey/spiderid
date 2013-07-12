class Species < ActiveRecord::Base
	# The improper singular of species was used here to avoid confusing rails
  # attr_accessible :family_id, :genera_id,
 	# :scientific_name, :common_name, :permalink, :description, :venomous, :characteristics, :image_url
  belongs_to :family
  belongs_to :genera

  def full_scientific_name
  	return "#{self.genera.name} #{self.scientific_name}"
  end

end