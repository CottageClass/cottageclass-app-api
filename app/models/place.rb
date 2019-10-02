class Place < ApplicationRecord
  belongs_to :creator, inverse_of: :created_places, class_name: 'User', foreign_key: :user_id
  has_many :event_series, inverse_of: :place, dependent: :destroy
  has_many :events, through: :event_series, inverse_of: :place
  has_many :users, inverse_of: :place

  before_validation :retrieve_details

  validates :google_id, presence: true, uniqueness: { case_sensitive: true }
  validates :full_address, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true

  before_save :obfuscate_location, :generate_time_zone,
              if: proc { |instance| instance.latitude_changed? || instance.longitude_changed? }

  after_validation :geocode, if: lambda { |instance|
    instance.full_address.present? && (instance.latitude.blank? || instance.longitude.blank?)
  }
  geocoded_by :full_address

  def obfuscate_location
    location = if (latitude.present? && latitude.nonzero?) && (longitude.present? && longitude.nonzero?)
                 # update dependent events
                 events.update_all latitude: latitude, longitude: longitude

                 Locator.obfuscate latitude: latitude, longitude: longitude
               else
                 { fuzzy_latitude: nil, fuzzy_longitude: nil }
               end
    assign_attributes location
  end

  def full_address
    [
      [street_number, route].compact.map(&:squish).select(&:present?).join(' '),
      locality,
      admin_area_level_1,
      admin_area_level_2,
      [country, postal_code].compact.map(&:squish).select(&:present?).join(' ')
    ].compact.map(&:squish).select(&:present?).join(', ')
  end

  private

  def generate_time_zone
    self.time_zone = if (latitude.present? && latitude.nonzero?) && (longitude.present? && longitude.nonzero?)
                       Locator.time_zone_for latitude: latitude, longitude: longitude
                     end
  end

  def retrieve_details
    @client = GooglePlaces::Client.new(ENV['GOOGLE_API_KEY'])
    if google_id.present? && @latitude.blank?
      req = @client.spot(google_id)
      self.latitude = req.lat
      self.longitude = req.lng
      self.full_address = req.formatted_address
      self.name = req.name
      self.locality = req.city
      self.admin_area_level_1 = req.region
    end
  end
end
