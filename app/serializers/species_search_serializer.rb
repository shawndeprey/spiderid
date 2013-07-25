class SpeciesSearchSerializer < ActiveModel::Serializer
  attributes :id, :permalink, :common_name, :characteristics, :description, :family_name, :genera_name, :scientific_name, 
  :other_names, :overview, :locations_found, :additional_info, :adult_size, :author
end
