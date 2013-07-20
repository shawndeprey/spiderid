class AddAuthorToSpecies < ActiveRecord::Migration
  def change
  	add_column :species, :author, :string
  	add_column :species, :additional_info, :text
  end
end
