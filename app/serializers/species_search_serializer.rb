class SpeciesSearchSerializer < ActiveModel::Serializer
  attributes :id, :permalink, :family_name, :genera_name, :scientific_name, :common_name, :other_names, :description, :overview,
  :locations_found, :adult_size, :characteristics, :author, :additional_info
end
