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

ActiveRecord::Schema.define(version: 2018_10_20_064135) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "children", force: :cascade do |t|
    t.string "first_name"
    t.datetime "birthday"
    t.bigint "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_children_on_parent_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "facebook_uid"
    t.string "first_name"
    t.string "last_name"
    t.string "name"
    t.boolean "agree_tos", default: false
    t.string "street_number"
    t.string "route"
    t.string "locality"
    t.string "admin_area_level_1"
    t.string "admin_area_level_2"
    t.string "country", default: "United States"
    t.string "postal_code"
    t.string "latitude"
    t.string "longitude"
    t.string "phone_area_code"
    t.string "phone_country_code", default: "1"
    t.string "phone_number"
    t.text "activities", default: [], array: true
    t.boolean "available_mornings"
    t.boolean "available_afternoons"
    t.boolean "available_evenings"
    t.boolean "available_weekends"
    t.string "network_code"
    t.index ["network_code"], name: "index_users_on_network_code"
  end

  add_foreign_key "children", "users", column: "parent_id"
end
