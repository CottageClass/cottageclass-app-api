module Serializers
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
      :activities,
      :phone,
      :full_address
  end
end
