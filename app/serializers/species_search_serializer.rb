class SpeciesSearchSerializer < ActiveModel::Serializer
  attributes :id, :family_name, :genera_name, :scientific_name 
end
