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

ActiveRecord::Schema.define(version: 2018_12_28_091932) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "children", force: :cascade do |t|
    t.string "first_name"
    t.string "school_name"
    t.datetime "birthday"
    t.bigint "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_children_on_parent_id"
  end

  create_table "event_hosts", force: :cascade do |t|
    t.string "name", null: false
    t.string "email"
    t.string "phone"
    t.boolean "verified", default: false
    t.json "meta"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_hosts_events", id: false, force: :cascade do |t|
    t.bigint "event_host_id", null: false
    t.bigint "event_id", null: false
    t.index ["event_host_id", "event_id"], name: "index_event_hosts_events_on_event_host_id_and_event_id", unique: true
  end

  create_table "event_hosts_series", id: false, force: :cascade do |t|
    t.bigint "event_host_id", null: false
    t.bigint "event_series_id", null: false
    t.index ["event_host_id", "event_series_id"], name: "index_event_hosts_series_on_event_host_id_and_event_series_id", unique: true
  end

  create_table "event_series", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.string "time_zone"
    t.date "start_date", null: false
    t.time "starts_at", null: false
    t.time "ends_at", null: false
    t.integer "repeat_for", null: false
    t.integer "interval", null: false
    t.integer "maximum_children", default: 0
    t.integer "child_age_minimum", default: 0
    t.integer "child_age_maximum", default: 0
    t.boolean "has_pet", default: false
    t.text "activity_names", default: [], array: true
    t.text "foods", default: [], array: true
    t.text "house_rules"
    t.text "pet_description"
    t.json "meta"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "index_event_series_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.bigint "event_series_id", null: false
    t.string "name", null: false
    t.string "time_zone"
    t.datetime "starts_at", null: false
    t.datetime "ends_at", null: false
    t.integer "maximum_children", default: 0
    t.integer "child_age_minimum", default: 0
    t.integer "child_age_maximum", default: 0
    t.boolean "modified", default: false
    t.boolean "has_pet", default: false
    t.text "activity_names", default: [], array: true
    t.text "foods", default: [], array: true
    t.text "house_rules"
    t.text "pet_description"
    t.json "meta"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["event_series_id"], name: "index_events_on_event_series_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "sender_id"
    t.bigint "receiver_id"
    t.text "content"
    t.bigint "cc_twilio_session_id"
    t.string "twilio_interaction_sid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cc_twilio_session_id"], name: "index_messages_on_cc_twilio_session_id"
    t.index ["receiver_id"], name: "index_messages_on_receiver_id"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
  end

  create_table "participant_children", force: :cascade do |t|
    t.bigint "participant_id", null: false
    t.string "participable_type", null: false
    t.bigint "participable_id", null: false
    t.bigint "child_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["participable_type", "participable_id", "child_id"], name: "idx_participants_on_participable_type_participable_id_child_id", unique: true
    t.index ["participant_id"], name: "index_participant_children_on_participant_id"
  end

  create_table "participants", force: :cascade do |t|
    t.string "participable_type", null: false
    t.bigint "participable_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["participable_type", "participable_id", "user_id"], name: "index_participants_on_participable_type_participable_id_user_id", unique: true
  end

  create_table "twilio_sessions", force: :cascade do |t|
    t.string "friendly_name"
    t.string "twilio_id"
    t.string "twilio_sid_sender"
    t.string "twilio_sid_receiver"
    t.datetime "last_action_at", default: -> { "CURRENT_TIMESTAMP" }
    t.string "proxy_identifier_sender"
    t.string "proxy_identifier_receiver"
    t.bigint "sender_id"
    t.bigint "receiver_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["receiver_id"], name: "index_twilio_sessions_on_receiver_id"
    t.index ["sender_id"], name: "index_twilio_sessions_on_sender_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "avatar"
    t.decimal "fuzzy_latitude"
    t.decimal "fuzzy_longitude"
    t.string "password_digest"
    t.string "time_zone"
    t.boolean "verified", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "facebook_uid"
    t.string "first_name"
    t.string "last_name"
    t.string "name"
    t.boolean "agree_tos", default: false
    t.decimal "latitude"
    t.decimal "longitude"
    t.string "street_number"
    t.string "route"
    t.string "locality"
    t.string "admin_area_level_1"
    t.string "admin_area_level_2"
    t.string "postal_code"
    t.string "phone_area_code"
    t.string "phone_number"
    t.string "country", default: "United States"
    t.string "phone_country_code", default: "1"
    t.text "activities", default: [], array: true
    t.boolean "available_mornings"
    t.boolean "available_afternoons"
    t.boolean "available_evenings"
    t.boolean "available_weekends"
    t.string "network_code"
    t.string "facebook_access_token"
    t.datetime "fb_access_token_expires_at", default: -> { "CURRENT_TIMESTAMP" }
    t.text "profile_blurb"
    t.string "onboarding_care_type"
    t.index ["fuzzy_latitude", "fuzzy_longitude"], name: "index_users_on_fuzzy_latitude_and_fuzzy_longitude"
    t.index ["latitude", "longitude"], name: "index_users_on_latitude_and_longitude"
    t.index ["network_code"], name: "index_users_on_network_code"
  end

  add_foreign_key "children", "users", column: "parent_id"
  add_foreign_key "messages", "twilio_sessions", column: "cc_twilio_session_id"
  add_foreign_key "messages", "users", column: "receiver_id"
  add_foreign_key "messages", "users", column: "sender_id"
  add_foreign_key "twilio_sessions", "users", column: "receiver_id"
  add_foreign_key "twilio_sessions", "users", column: "sender_id"
end
