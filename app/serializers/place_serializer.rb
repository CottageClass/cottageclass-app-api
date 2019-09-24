class PlaceSerializer < BaseSerializer
  # private aspects of place
  attribute :google_id, if: proc { |record| record.public }
  attribute :apartment_number, if: proc { |record| record.public }
  attribute :full_address, if: proc { |record| record.public }
  attribute :latitude, if: proc { |record| record.public }
  attribute :longitude, if: proc { |record| record.public }
  attribute :route, if: proc { |record| record.public }
  attribute :phone_area_code, if: proc { |record| record.public }
  attribute :phone_country_code, if: proc { |record| record.public }
  attribute :phone_number, if: proc { |record| record.public }
  attribute :street_number, if: proc { |record| record.public }

  # public aspects of place
  attributes :locality,
             :sublocality,
             :neighborhood,
             :admin_area_level_1,
             :admin_area_level_2,
             :fuzzy_latitude,
             :fuzzy_longitude,
             :postal_code,
             :country
end
