class UpdateSpeciesModel < ActiveRecord::Migration
  def up
  	rename_column :species, :venomous, :dangerous_bite
  	add_column :species, :other_names, :string
  	add_column :species, :overview, :text
  	add_column :species, :bite_effects, :text
  	add_column :species, :locations_found, :text
  	add_column :species, :adult_size, :string
  end

  def down
  	rename_column :species, :dangerous_bite, :venomous 
  	remove_column :species, :other_names
  	remove_column :species, :overview
  	remove_column :species, :bite_effects
  	remove_column :species, :locations_found
  	remove_column :species, :adult_size
  end
end
