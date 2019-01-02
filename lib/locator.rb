module Locator
  def obfuscate(latitude:, longitude:, range: 0.1..0.2)
    fuzzy_latitude = 0
    fuzzy_longitude = 0
    distance = 0

    while range.exclude?(distance)
      fuzzy_latitude, fuzzy_longitude = Geocoder::Calculations.random_point_near [latitude, longitude], range.last
      distance = Geocoder::Calculations.distance_between [fuzzy_latitude, fuzzy_longitude], [latitude, longitude]
    end

    { fuzzy_latitude: fuzzy_latitude, fuzzy_longitude: fuzzy_longitude }
  end

  def time_zone_for(latitude:, longitude:)
    name = nil
    begin
      timezone = Timezone.lookup latitude, longitude
      name = timezone.name
    rescue Timezone::Error::InvalidZone => e
      Rails.logger.error e
    end
    name
  end

  module_function :obfuscate, :time_zone_for
end
