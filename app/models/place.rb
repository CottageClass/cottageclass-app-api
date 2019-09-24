class Place < ApplicationRecord
  belongs_to :user, inverse_of: :places
  has_many :events, inverse_of: :place

  before_validation :retrieve_details

  validates :google_id, presence: true, uniqueness: { case_sensitive: true }
  validates :full_address, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true

  after_validation :geocode, if: lambda { |instance|
    instance.full_address.present? && (instance.latitude.blank? || instance.longitude.blank?)
  }
  geocoded_by :full_address

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
