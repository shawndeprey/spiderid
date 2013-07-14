class SpeciesSearchSerializer < ActiveModel::Serializer
  attributes :id, :scientific_name, :genera_name, :family_name
end
