class UserInNetworkSerializer < BaseSerializer
  has_many :children

  attributes :first_name,
             :last_name,
             :avatar,
             :latitude,
             :longitude,
             :available_mornings,
             :available_afternoons,
             :available_evenings,
             :available_weekends,
             :activities,
             :full_address,
             :network_code,
             :facebook_id,
             :profile_blurb,
             :onboarding_care_type

  with_options if: proc { |_, params| params && params[:personal_information] == true } do
    attribute :phone
  end
end
