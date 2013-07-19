class Species < ActiveRecord::Base
	include Tire::Model::Search
  include Tire::Model::Callbacks
  nilify_blanks
  after_touch() { tire.update_index }

  # The improper singular of species was used here to avoid confusing rails
  # attr_accessible :family_id, :genera_id,
  # :scientific_name, :common_name, :permalink, :description, :venomous, :characteristics, :image_url

  belongs_to :family
  belongs_to :genera

  def to_indexed_json
    SpeciesSearchSerializer.new(self).to_json(:root => false)
  end

  def full_scientific_name
  	return "#{self.genera.name} #{self.scientific_name}"
  end

  def genera_name
  	self.genera.blank? ? nil : self.genera.name
  end

  def family_name
  	self.family.blank? ? nil : self.family.name
  end

  def self.search_by(term, page)
    tire.search page: page, per_page: 50 do
      query do
      	# match [:scientific_name, :genera_name, :family_name], term
        string "#{term}*" unless term.blank?
      end
    end
  end

end