ActiveAdmin.register User do
  config.sort_order = 'id_desc'
  menu priority: 1

  includes :children

  permit_params :email, :facebook_uid, :internally_cleared, :verified, :first_name, :last_name, :name, :profile_blurb,
                :referrer, :setting_email_notifications, :setting_max_distance, source_tags: []

  filter :name
  filter :first_name
  filter :last_name
  filter :verified
  filter :facebook_uid
  filter :created_at
  filter :phone_number, label: 'phone: 5551234'
  filter :email

  index do
    selectable_column
    column :id
    column :name
    column :internally_cleared
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
      verified
      neighborhood
      sublocality
      images
      languages
      job_position
      employer
      highest_education
      school
      source_tags
      child_ages_in_months
      child_names
      setting_email_notifications
      setting_max_distance
    ].each do |attribute|
      column attribute
    end
    column :nearest_upcoming_event do |instance|
      event = instance.nearest_upcoming_event
      root_url + 'event/' + event.id.to_s if event.present?
    end
  end
end
