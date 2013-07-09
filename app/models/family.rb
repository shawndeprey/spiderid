class Family < ActiveRecord::Base
  #attr_accessible :name, :total_genus, :total_species
  has_many :generas # The improper plural of genus was used here to avoid confusing Rails
  has_many :species

  before_save :denormalize

  def denormalize
  	self.total_genus = self.generas.length
  	self.total_species = self.species.length
  end
end
