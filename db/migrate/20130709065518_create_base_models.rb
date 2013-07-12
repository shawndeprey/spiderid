class CreateBaseModels < ActiveRecord::Migration
  def change
    create_table :families do |t|
    	t.string :name
      t.integer :total_genus
      t.integer :total_species
      t.timestamps
    end
    create_table :generas do |t|
    	t.string :name
      t.integer :total_species
      t.integer :family_id
      t.timestamps
    end
    create_table :species do |t|
      t.integer :family_id
      t.integer :genera_id
      t.string :scientific_name
      t.string :common_name
      t.string :permalink
      t.text :description
      t.boolean :venomous
      t.text :characteristics
      t.text :image_url
      t.timestamps
    end
  end
end
