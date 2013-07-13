# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20130713191220) do

  create_table "families", force: true do |t|
    t.string   "name"
    t.integer  "total_genus"
    t.integer  "total_species"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "families", ["name"], name: "index_families_on_name", using: :btree

  create_table "generas", force: true do |t|
    t.string   "name"
    t.integer  "total_species"
    t.integer  "family_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "generas", ["family_id"], name: "index_generas_on_family_id", using: :btree
  add_index "generas", ["name"], name: "index_generas_on_name", using: :btree

  create_table "species", force: true do |t|
    t.integer  "family_id"
    t.integer  "genera_id"
    t.string   "scientific_name"
    t.string   "common_name"
    t.string   "permalink"
    t.text     "description"
    t.boolean  "venomous"
    t.text     "characteristics"
    t.text     "image_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "species", ["family_id"], name: "index_species_on_family_id", using: :btree
  add_index "species", ["genera_id"], name: "index_species_on_genera_id", using: :btree
  add_index "species", ["scientific_name"], name: "index_species_on_scientific_name", using: :btree

end
