class Genera < ActiveRecord::Base
  #attr_accessible :name, :total_species, :family_id
  belongs_to :family
  has_many :species

  before_save :denormalize

  def denormalize
  	self.total_species = self.species.length
  end
end
