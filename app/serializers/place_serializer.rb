class PlaceSerializer < BaseSerializer
  full_information = proc { |record, params|
    record.public || params[:current_users_place]
  }
  has_many :upcoming_events, serializer: EventSerializer

  # private aspects of place
  attribute :id, if: full_information
  attribute :google_id, if: full_information
  attribute :apartment_number, if: full_information
  attribute :full_address, if: full_information
  attribute :latitude, if: full_information
  attribute :longitude, if: full_information
  attribute :phone_country_code, if: full_information
  attribute :name, if: full_information

  # public aspects of place
  attributes :public,
             :locality,
             :vicinity,
             :neighborhood,
             :admin_area_level_1,
             :fuzzy_latitude,
             :fuzzy_longitude,
             :country,
             :images
end
