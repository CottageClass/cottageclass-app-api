ActiveAdmin.register User do
  config.sort_order = 'id_desc'
  menu priority: 1

  includes :children

  permit_params :email, :facebook_uid, :internally_cleared, :pause_suggestion_email, :verified, :first_name, :last_name, :name, :profile_blurb,
                :settings, :apartment_number, :referrer, source_tags: []

  filter :name
  filter :first_name
  filter :last_name
  filter :verified
  filter :facebook_uid
  filter :created_at
  filter :pause_suggestion_email
  filter :phone_number, label: 'phone: 5551234'
  filter :email

  index do
    selectable_column
    column :id
    column :name
    column :internally_cleared
    column :pause_suggestion_email
    bool_column :verified
    column :facebook_uid
    column :created_at
    actions do |instance|
      item 'Notifications', admin_user_notifications_path(instance), class: 'member_link'
    end
  end

  csv force_quotes: true do
    %i[
      id
      email
      created_at
      updated_at
      facebook_uid
      first_name
      last_name
      name
      full_address
      street_number
      route
      locality
      admin_area_level_1
      admin_area_level_2
      country
      postal_code
      phone
      phone_area_code
      phone_country_code
      phone_number
      activities
      available_mornings
      available_afternoons
      available_evenings
      available_weekends
      profile_blurb
      onboarding_care_type
      avatar
      latitude
      longitude
      fuzzy_latitude
      fuzzy_longitude
      has_pet
      pet_description
      house_rules
      time_zone
      verified
      neighborhood
      sublocality
      apartment_number
      images
      languages
      job_position
      employer
      highest_education
      school
      instagram_user
      twitter_user
      linkedin_user
      referrer
      source_tags
      child_ages_in_months
      child_names
      pause_suggestion_email
    ].each do |attribute|
      column attribute
    end
    column :nearest_upcoming_event do |instance|
      event = instance.nearest_upcoming_event
      root_url + 'event/' + event.id.to_s if event.present?
    end
    User::STORED_MATCHES.times do |item|
      column "match_#{item}" do |instance|
        instance.active_user_matches[item].matched_user_id if instance.active_user_matches[item].present?
      end
    end
  end
end
