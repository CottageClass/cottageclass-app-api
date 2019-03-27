class UserSerializer < BaseSerializer
  has_many :children, serializer: ChildUnrestrictedSerializer
  has_many :user_reviews

  attributes :agree_tos,
             :first_name,
             :last_name,
             :verified,
             :avatar,
             :facebook_uid,
             :facebook_access_token,
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
             :activities,
             :phone,
             :full_address,
             :profile_blurb,
             :onboarding_care_type,
             :job_position,
             :employer,
             :highest_education,
             :school,
             :instagram_user,
             :twitter_user,
             :linkedin_user,
             :images,
             :languages

  attribute :date_created, &:created_at
  attribute(:hosted_events_count) { |instance, _| instance.events.past.count }
  attribute(:participated_events_count) { |instance, _| instance.participated_events.past.count }
end
