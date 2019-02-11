ActiveAdmin.register User do
  config.sort_order = 'id_desc'
  menu priority: 1

  includes :children

  permit_params :email, :facebook_uid, :verified, :first_name, :last_name, :name, :network_code, :profile_blurb,
                :apartment_number

  filter :name
  filter :first_name
  filter :last_name
  filter :verified
  filter :network_code
  filter :facebook_uid
  filter :created_at

  index do
    selectable_column
    column :id
    column :name
    bool_column :verified
    column :network_code
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
      network_code
      profile_blurb
      onboarding_care_type
      avatar
      latitude
      longitude
      fuzzy_latitude
      fuzzy_longitude
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
      child_ages
      child_names
    ].each do |attribute|
      column attribute
    end
    column :nearest_event do |instance|
      event = Event.upcoming.where.not(id: instance.events).near([instance.latitude, instance.longitude], 100).first
      event.present? ? edit_admin_event_url(event) : nil
    end
  end
end
