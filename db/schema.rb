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

ActiveRecord::Schema.define(version: 2019_12_13_172032) do

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

  create_table "children", force: :cascade do |t|
    t.string "first_name"
    t.string "school_name"
    t.datetime "birthday"
    t.bigint "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_children_on_parent_id"
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "sender_id"
    t.bigint "group_id"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_comments_on_group_id"
    t.index ["sender_id"], name: "index_comments_on_sender_id"
  end

  create_table "conversations", force: :cascade do |t|
    t.bigint "initiator_id"
    t.bigint "recipient_id"
    t.bigint "last_message_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["initiator_id", "recipient_id"], name: "index_conversations_on_initiator_id_and_recipient_id", unique: true
    t.index ["initiator_id"], name: "index_conversations_on_initiator_id"
    t.index ["last_message_id"], name: "index_conversations_on_last_message_id"
    t.index ["recipient_id"], name: "index_conversations_on_recipient_id"
  end

  create_table "dark_stars", force: :cascade do |t|
    t.bigint "giver_id"
    t.bigint "recipient_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["giver_id"], name: "index_dark_stars_on_giver_id"
    t.index ["recipient_id"], name: "index_dark_stars_on_recipient_id"
  end

  create_table "devices", force: :cascade do |t|
    t.string "token"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "platform", default: 0, null: false
    t.index ["token"], name: "index_devices_on_token"
    t.index ["user_id"], name: "index_devices_on_user_id"
  end

  create_table "event_collection_memberships", force: :cascade do |t|
    t.bigint "event_id"
    t.bigint "event_collection_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_collection_id"], name: "index_event_collection_memberships_on_event_collection_id"
    t.index ["event_id"], name: "index_event_collection_memberships_on_event_id"
  end

  create_table "event_collections", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "event_series", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.date "start_date", null: false
    t.time "starts_at", null: false
    t.time "ends_at", null: false
    t.integer "repeat_for", null: false
    t.integer "interval", null: false
    t.integer "child_age_minimum", default: 0
    t.integer "child_age_maximum", default: 0
    t.json "meta"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.bigint "place_id"
    t.text "description"
    t.text "images", default: [], array: true
    t.decimal "latitude"
    t.decimal "longitude"
    t.index ["place_id"], name: "index_event_series_on_place_id"
    t.index ["user_id"], name: "index_event_series_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.bigint "event_series_id", null: false
    t.string "name", null: false
    t.datetime "starts_at", null: false
    t.datetime "ends_at", null: false
    t.integer "child_age_minimum", default: 0
    t.integer "child_age_maximum", default: 0
    t.boolean "modified", default: false
    t.json "meta"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "description"
    t.text "images", default: [], array: true
    t.decimal "latitude"
    t.decimal "longitude"
    t.index ["event_series_id"], name: "index_events_on_event_series_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "sender_id"
    t.bigint "receiver_id"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "participants", force: :cascade do |t|
    t.string "participable_type", null: false
    t.bigint "participable_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["participable_type", "participable_id", "user_id"], name: "index_participants_on_participable_type_participable_id_user_id", unique: true
  end

  create_table "place_reviews", force: :cascade do |t|
    t.bigint "place_id"
    t.bigint "user_id"
    t.integer "stars"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["place_id"], name: "index_place_reviews_on_place_id"
    t.index ["user_id"], name: "index_place_reviews_on_user_id"
  end

  create_table "places", force: :cascade do |t|
    t.string "google_id", null: false
    t.float "latitude", null: false
    t.float "longitude", null: false
    t.string "full_address", null: false
    t.boolean "public", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "fuzzy_latitude"
    t.decimal "fuzzy_longitude"
    t.string "locality"
    t.string "neighborhood"
    t.string "admin_area_level_1"
    t.string "apartment_number"
    t.string "country", default: "United States"
    t.string "phone_country_code", default: "1"
    t.string "name"
    t.string "time_zone"
    t.jsonb "full_result_object"
    t.string "vicinity"
    t.string "images", default: [], array: true
    t.index ["google_id", "apartment_number"], name: "index_places_google_id_apartment_number", unique: true
    t.index ["latitude", "longitude"], name: "index_places_on_latitude_and_longitude"
    t.index ["user_id"], name: "index_places_on_user_id"
  end

  create_table "rpush_apps", force: :cascade do |t|
    t.string "name", null: false
    t.string "environment"
    t.text "certificate"
    t.string "password"
    t.integer "connections", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type", null: false
    t.string "auth_key"
    t.string "client_id"
    t.string "client_secret"
    t.string "access_token"
    t.datetime "access_token_expiration"
    t.text "apn_key"
    t.string "apn_key_id"
    t.string "team_id"
    t.string "bundle_id"
    t.boolean "feedback_enabled", default: true
  end

  create_table "rpush_feedback", force: :cascade do |t|
    t.string "device_token"
    t.datetime "failed_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "app_id"
    t.index ["device_token"], name: "index_rpush_feedback_on_device_token"
  end

  create_table "rpush_notifications", force: :cascade do |t|
    t.integer "badge"
    t.string "device_token"
    t.string "sound"
    t.text "alert"
    t.text "data"
    t.integer "expiry", default: 86400
    t.boolean "delivered", default: false, null: false
    t.datetime "delivered_at"
    t.boolean "failed", default: false, null: false
    t.datetime "failed_at"
    t.integer "error_code"
    t.text "error_description"
    t.datetime "deliver_after"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "alert_is_json", default: false, null: false
    t.string "type", null: false
    t.string "collapse_key"
    t.boolean "delay_while_idle", default: false, null: false
    t.text "registration_ids"
    t.integer "app_id", null: false
    t.integer "retries", default: 0
    t.string "uri"
    t.datetime "fail_after"
    t.boolean "processing", default: false, null: false
    t.integer "priority"
    t.text "url_args"
    t.string "category"
    t.boolean "content_available", default: false, null: false
    t.text "notification"
    t.boolean "mutable_content", default: false, null: false
    t.string "external_device_id"
    t.string "thread_id"
    t.boolean "dry_run", default: false, null: false
    t.index ["delivered", "failed", "processing", "deliver_after", "created_at"], name: "index_rpush_notifications_multi", where: "((NOT delivered) AND (NOT failed))"
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

  create_table "user_group_memberships", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "user_group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_group_id"], name: "index_user_group_memberships_on_user_group_id"
    t.index ["user_id", "user_group_id"], name: "index_user_group_memberships_on_user_id_and_user_group_id", unique: true
    t.index ["user_id"], name: "index_user_group_memberships_on_user_id"
  end

  create_table "user_groups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "avatar"
    t.string "legacy_password_digest"
    t.boolean "verified", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "facebook_uid"
    t.string "first_name"
    t.string "last_name"
    t.string "name"
    t.string "postal_code"
    t.string "phone_area_code"
    t.string "phone_number"
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
    t.boolean "internally_cleared", default: false, null: false
    t.decimal "setting_max_distance", default: "2.0"
    t.boolean "setting_email_notifications", default: true
    t.bigint "place_id"
    t.decimal "latitude"
    t.decimal "longitude"
    t.boolean "setting_notify_messages_push", default: true
    t.boolean "setting_notify_messages_email", default: true
    t.boolean "setting_notify_messages_sms", default: true
    t.boolean "setting_notify_group_messages_push", default: true
    t.boolean "setting_notify_group_messages_email", default: true
    t.boolean "setting_notify_group_messages_sms", default: true
    t.boolean "setting_notify_event_reminder_push", default: true
    t.boolean "setting_notify_event_reminder_email", default: true
    t.boolean "setting_notify_event_reminder_sms", default: true
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email"
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["place_id"], name: "index_users_on_place_id"
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "children", "users", column: "parent_id"
  add_foreign_key "conversations", "messages", column: "last_message_id"
  add_foreign_key "conversations", "users", column: "initiator_id"
  add_foreign_key "conversations", "users", column: "recipient_id"
  add_foreign_key "dark_stars", "users", column: "giver_id"
  add_foreign_key "dark_stars", "users", column: "recipient_id"
  add_foreign_key "devices", "users"
  add_foreign_key "event_collection_memberships", "event_collections"
  add_foreign_key "event_collection_memberships", "events"
  add_foreign_key "event_series", "places"
  add_foreign_key "messages", "users", column: "receiver_id"
  add_foreign_key "messages", "users", column: "sender_id"
  add_foreign_key "place_reviews", "places"
  add_foreign_key "place_reviews", "users"
  add_foreign_key "places", "users"
  add_foreign_key "stars", "users", column: "giver_id"
  add_foreign_key "user_group_memberships", "user_groups"
  add_foreign_key "user_group_memberships", "users"
  add_foreign_key "users", "places"
end
