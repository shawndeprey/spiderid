class AddIndexesForAllModels < ActiveRecord::Migration
  def up
    add_index :species, :family_id
    add_index :species, :genera_id
    add_index :species, :scientific_name
    add_index :generas, :family_id
    add_index :generas, :name
    add_index :families, :name
  end

  def down
    remove_index :species, :family_id
    remove_index :species, :genera_id
    remove_index :species, :scientific_name
    remove_index :generas, :family_id
    remove_index :generas, :name
    remove_index :families, :name
  end
end
