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

ActiveRecord::Schema.define(version: 2019_09_09_162753) do

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

  create_table "ahoy_events", force: :cascade do |t|
    t.bigint "visit_id"
    t.bigint "user_id"
    t.string "name"
    t.jsonb "properties"
    t.datetime "time"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time"
    t.index ["properties"], name: "index_ahoy_events_on_properties", opclass: :jsonb_path_ops, using: :gin
    t.index ["user_id"], name: "index_ahoy_events_on_user_id"
    t.index ["visit_id"], name: "index_ahoy_events_on_visit_id"
  end

  create_table "ahoy_visits", force: :cascade do |t|
    t.string "visit_token"
    t.string "visitor_token"
    t.bigint "user_id"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.string "referring_domain"
    t.text "landing_page"
    t.string "browser"
    t.string "os"
    t.string "device_type"
    t.string "country"
    t.string "region"
    t.string "city"
    t.float "latitude"
    t.float "longitude"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.string "app_version"
    t.string "os_version"
    t.string "platform"
    t.datetime "started_at"
    t.index ["user_id"], name: "index_ahoy_visits_on_user_id"
    t.index ["visit_token"], name: "index_ahoy_visits_on_visit_token", unique: true
  end

  create_table "childcare_requests", force: :cascade do |t|
    t.bigint "user_id"
    t.text "content"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["user_id"], name: "index_childcare_requests_on_user_id"
  end

  create_table "children", force: :cascade do |t|
    t.string "first_name"
    t.string "school_name"
    t.datetime "birthday"
    t.bigint "parent_id"
    t.text "allergies", default: [], array: true
    t.text "dietary_restrictions", default: [], array: true
    t.text "special_needs"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_children_on_parent_id"
  end

  create_table "dark_stars", force: :cascade do |t|
    t.bigint "giver_id"
    t.bigint "recipient_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["giver_id"], name: "index_dark_stars_on_giver_id"
    t.index ["recipient_id"], name: "index_dark_stars_on_recipient_id"
  end

  create_table "emergency_contacts", force: :cascade do |t|
    t.string "contactable_type", null: false
    t.bigint "contactable_id", null: false
    t.string "name"
    t.string "phone_number"
    t.string "relationship"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["contactable_type", "contactable_id"], name: "index_emergency_contacts_on_contactable_type_and_contactable_id"
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
    t.json "meta"
    t.decimal "latitude"
    t.decimal "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float "recency_score"
    t.index ["event_series_id"], name: "index_events_on_event_series_id"
    t.index ["latitude", "longitude"], name: "index_events_on_latitude_and_longitude"
  end

  create_table "key_values", force: :cascade do |t|
    t.string "key", null: false
    t.text "value", null: false
    t.index ["key"], name: "index_key_values_on_key", unique: true
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

  create_table "notifications", force: :cascade do |t|
    t.text "body", null: false
    t.bigint "recipient_id", null: false
    t.string "notifiable_type"
    t.bigint "notifiable_id"
    t.integer "kind", default: 0
    t.string "sms_provider_identifier"
    t.string "email_provider_identifier"
    t.string "status"
    t.json "meta"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable_type_and_notifiable_id"
    t.index ["recipient_id"], name: "index_notifications_on_recipient_id"
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

  create_table "search_list_items", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "itemable_type"
    t.bigint "itemable_id"
    t.index ["itemable_type", "itemable_id"], name: "index_search_list_items_on_itemable_type_and_itemable_id"
    t.index ["user_id", "itemable_type", "itemable_id"], name: "index_items_on_itemable_type_itemable_id_user_id", unique: true
    t.index ["user_id"], name: "index_items_on_user_with_null_itemable", unique: true, where: "(itemable_id IS NULL)"
    t.index ["user_id"], name: "index_search_list_items_on_user_id"
  end

  create_table "stars", force: :cascade do |t|
    t.string "starable_type"
    t.bigint "starable_id"
    t.bigint "giver_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["giver_id", "starable_type", "starable_id"], name: "index_stars_on_starable_type_starable_id_giver_id", unique: true
    t.index ["giver_id"], name: "index_stars_on_giver_id"
    t.index ["starable_type", "starable_id"], name: "index_stars_on_starable_type_and_starable_id"
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

  create_table "user_matches", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "matched_user_id"
    t.float "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["matched_user_id"], name: "index_user_matches_on_matched_user_id"
    t.index ["user_id", "matched_user_id"], name: "index_user_matches_on_user_id_matched_user_id", unique: true
    t.index ["user_id"], name: "index_user_matches_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "avatar"
    t.string "referrer"
    t.decimal "fuzzy_latitude"
    t.decimal "fuzzy_longitude"
    t.string "legacy_password_digest"
    t.string "apartment_number"
    t.string "neighborhood"
    t.string "sublocality"
    t.string "time_zone"
    t.text "source_tags", default: [], array: true
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
    t.string "facebook_access_token"
    t.datetime "fb_access_token_expires_at", default: -> { "CURRENT_TIMESTAMP" }
    t.text "profile_blurb"
    t.string "onboarding_care_type"
    t.text "images", default: [], array: true
    t.text "languages", default: [], array: true
    t.string "job_position"
    t.string "employer"
    t.string "highest_education"
    t.string "school"
    t.string "instagram_user"
    t.string "twitter_user"
    t.string "linkedin_user"
    t.string "encrypted_password", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.string "unconfirmed_email"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.integer "invitations_count", default: 0
    t.string "provider"
    t.string "uid"
    t.string "jti", null: false
    t.boolean "terms_of_service", default: false, null: false
    t.boolean "has_pet"
    t.text "pet_description"
    t.text "house_rules"
    t.bigint "showcase_event_id"
    t.boolean "internally_cleared", default: false, null: false
    t.jsonb "settings", default: {}
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email"
    t.index ["fuzzy_latitude", "fuzzy_longitude"], name: "index_users_on_fuzzy_latitude_and_fuzzy_longitude"
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["latitude", "longitude"], name: "index_users_on_latitude_and_longitude"
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["showcase_event_id"], name: "index_users_on_showcase_event_id"
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "childcare_requests", "users"
  add_foreign_key "children", "users", column: "parent_id"
  add_foreign_key "dark_stars", "users", column: "giver_id"
  add_foreign_key "dark_stars", "users", column: "recipient_id"
  add_foreign_key "messages", "twilio_sessions", column: "cc_twilio_session_id"
  add_foreign_key "messages", "users", column: "receiver_id"
  add_foreign_key "messages", "users", column: "sender_id"
  add_foreign_key "search_list_items", "users"
  add_foreign_key "stars", "users", column: "giver_id"
  add_foreign_key "twilio_sessions", "users", column: "receiver_id"
  add_foreign_key "twilio_sessions", "users", column: "sender_id"
  add_foreign_key "user_matches", "users"
  add_foreign_key "user_matches", "users", column: "matched_user_id"
  add_foreign_key "users", "events", column: "showcase_event_id"
end
