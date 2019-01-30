class UserInNetworkSerializer < BaseSerializer
  has_many :children
  has_many :user_reviews

  attributes :first_name,
             :last_name,
             :verified,
             :avatar,
             :facebook_id,
             :fuzzy_latitude,
             :fuzzy_longitude,
             :available_mornings,
             :available_afternoons,
             :available_evenings,
             :available_weekends,
             :activities,
             :full_address,
             :network_code,
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

  attribute(:hosted_events_count) { |instance, _| instance.events.past.count }
  attribute(:participated_events_count) { |instance, _| instance.participated_events.past.count }

  with_options if: proc { |_, params| params.dig(:personal_information) == true } do
    attribute :phone
  end
end
