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

ActiveRecord::Schema.define(version: 20130728175740) do

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
    t.boolean  "dangerous_bite"
    t.text     "characteristics"
    t.text     "image_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "other_names"
    t.text     "overview"
    t.text     "bite_effects"
    t.text     "locations_found"
    t.string   "adult_size"
    t.string   "author"
    t.text     "additional_info"
  end

  add_index "species", ["family_id"], name: "index_species_on_family_id", using: :btree
  add_index "species", ["genera_id"], name: "index_species_on_genera_id", using: :btree
  add_index "species", ["scientific_name"], name: "index_species_on_scientific_name", using: :btree

  create_table "users", force: true do |t|
    t.boolean  "admin",                  default: false
    t.string   "first_name",                             null: false
    t.string   "last_name"
    t.string   "title"
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
