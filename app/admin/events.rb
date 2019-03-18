ActiveAdmin.register Event do
  config.sort_order = 'id_desc'
  menu parent: 'Data'

  includes :user, :event_series

  belongs_to :event_series, optional: true

  actions :index, :new, :create, :edit, :update, :destroy

  permit_params :name, :starts_at, :ends_at, :maximum_children, :child_age_minimum, :child_age_maximum, :has_pet,
                :house_rules, :pet_description,
                activity_names: [], foods: [], event_hosts_attributes: %i[id verified _destroy]

  filter :name

  before_save do |instance|
    instance.activity_names = (params.dig(:event, :activity_names) || '').split(',').try :flatten
    instance.foods = (params.dig(:event, :foods) || '').split(',').try :flatten
  end

  index do
    selectable_column
    column :id
    column :name
    column :event_series
    column :user
    column(:starts_at) { |instance| instance.in_instance_time_zone instance.starts_at }
    column(:ends_at) { |instance| instance.in_instance_time_zone instance.ends_at }
    column :created_at
    actions do |instance|
      item 'Participants', admin_event_participants_path(instance), class: 'member_link'
    end
  end

  csv force_quotes: true do
    {
      event: %i[
        id
        name
        starts_at
        ends_at
        modified
        maximum_children
        child_age_minimum
        child_age_maximum
        has_pet
        activity_names
        foods
        house_rules
        pet_description
        time_zone
        created_at
        updated_at
      ],
      user: %i[
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
      ]
    }.each do |key, attributes|
      attributes.each do |attribute|
        case key
        when :event
          column attribute
        when :user
          column(format('host_%s', attribute)) { |instance| instance.user.send attribute }
        end
      end
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    f.inputs 'Data' do
      f.input :name
      f.li do
        f.label :time_zone
        f.span f.object.time_zone
      end
      f.input :starts_at, hint: 'This is in UTC'
      f.input :ends_at, hint: 'This is in UTC'
      f.input :has_pet
      f.input :pet_description
      f.input :activity_names,
              as: :tags,
              hint: 'Though this input allows more than 1 item, entering more than 1 can lead to unexpected behavior'
      f.input :foods,
              as: :tags,
              hint: 'Though this input allows more than 1 item, entering more than 1 can lead to unexpected behavior'
      f.input :house_rules
      f.input :maximum_children
      f.input :child_age_minimum
      f.input :child_age_maximum
      f.li do
        f.label :created_at
        f.span f.object.created_at
      end
      f.li do
        f.label :updated_at
        f.span f.object.updated_at
      end
      f.has_many :event_hosts, allow_destroy: true do |event_host_f|
        event_host_f.input :name
        event_host_f.input :verified
      end
    end
    f.actions
  end
end
