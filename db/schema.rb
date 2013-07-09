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

ActiveRecord::Schema.define(version: 20130709065518) do

  create_table "families", force: true do |t|
    t.string   "name"
    t.integer  "total_genus"
    t.integer  "total_species"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "generas", force: true do |t|
    t.string   "name"
    t.integer  "total_species"
    t.integer  "family_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "species", force: true do |t|
    t.integer  "family_id"
    t.integer  "genera_id"
    t.string   "scientific_name"
    t.string   "common_name"
    t.string   "permalink"
    t.text     "description"
    t.boolean  "venomous"
    t.text     "attributes"
    t.text     "image_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
