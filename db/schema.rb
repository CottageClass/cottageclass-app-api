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

ActiveRecord::Schema.define(version: 2018_11_07_221551) do

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

  create_table "messages", force: :cascade do |t|
    t.bigint "sender_id"
    t.bigint "receiver_id"
    t.text "content"
    t.bigint "cc_twilio_session_id"
    t.string "twilio_interaction_sid"
    t.index ["cc_twilio_session_id"], name: "index_messages_on_cc_twilio_session_id"
    t.index ["receiver_id"], name: "index_messages_on_receiver_id"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
  end

  create_table "twilio_sessions", force: :cascade do |t|
    t.string "friendly_name"
    t.string "twilio_id"
    t.string "participant_ids", array: true
    t.string "twilio_sid_sender"
    t.string "twilio_sid_receiver"
    t.datetime "last_action_at"
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
    t.string "facebook_access_token"
    t.datetime "fb_access_token_expires_at", default: -> { "now()" }
    t.index ["network_code"], name: "index_users_on_network_code"
  end

  add_foreign_key "children", "users", column: "parent_id"
  add_foreign_key "messages", "twilio_sessions", column: "cc_twilio_session_id"
  add_foreign_key "messages", "users", column: "receiver_id"
  add_foreign_key "messages", "users", column: "sender_id"
end
