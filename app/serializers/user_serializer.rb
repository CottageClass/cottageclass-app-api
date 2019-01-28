class UserSerializer < BaseSerializer
  has_many :children, serializer: ChildUnrestrictedSerializer

  attributes :agree_tos,
             :first_name,
             :last_name,
             :verified,
             :avatar,
             :facebook_id,
             :apartment_number,
             :street_number,
             :route,
             :locality,
             :sublocality,
             :neighborhood,
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
             :activities,
             :phone,
             :full_address,
             :profile_blurb,
             :onboarding_care_type

  attribute :date_created, &:created_at
end
