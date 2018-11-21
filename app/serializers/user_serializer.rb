class UserSerializer < BaseSerializer
  has_many :children

  attributes :agree_tos,
    :first_name,
    :last_name,
    :street_number,
    :route,
    :locality,
    :admin_area_level_1,
    :admin_area_level_2,
    :country,
    :postal_code,
    :latitude,
    :longitude,
    :phone_country_code,
    :phone_area_code,
    :phone_number,
    :available_mornings,
    :available_afternoons,
    :available_evenings,
    :available_weekends,
    :network_code,
    :facebook_id,
    :activities,
    :phone,
    :full_address,
    :profile_blurb,
    :onboarding_care_type

  attribute :date_created, &:created_at
end
