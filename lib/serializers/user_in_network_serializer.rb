module Serializers
  class UserInNetworkSerializer < BaseSerializer
    attributes :first_name,
      :last_name,
      :latitude,
      :longitude,
      :available_mornings,
      :available_afternoons,
      :available_evenings,
      :available_weekends,
      :activities,
      :full_address,
      :phone,
      :network_code
  end
end
