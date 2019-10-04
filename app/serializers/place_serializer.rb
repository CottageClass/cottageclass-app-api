class PlaceSerializer < BaseSerializer
  full_information = proc { |record, params|
    record.public || params[:current_users_place]
  }

  # private aspects of place
  attribute :id, if: full_information
  attribute :google_id, if: full_information
  attribute :apartment_number, if: full_information
  attribute :full_address, if: full_information
  attribute :latitude, if: full_information
  attribute :longitude, if: full_information
  attribute :route, if: full_information
  attribute :phone_area_code, if: full_information
  attribute :phone_country_code, if: full_information
  attribute :phone_number, if: full_information
  attribute :street_number, if: full_information

  # public aspects of place
  attributes :public,
             :locality,
             :vicinity,
             :sublocality,
             :neighborhood,
             :admin_area_level_1,
             :admin_area_level_2,
             :fuzzy_latitude,
             :fuzzy_longitude,
             :postal_code,
             :country,
             :name
end
