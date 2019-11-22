require 'active_support/concern'

module Locatable
  extend ActiveSupport::Concern

  included do
    reverse_geocoded_by :latitude, :longitude
    before_save :update_location, if: lambda { |instance|
      instance.latitude.blank? || instance.longitude.blank? ||
        (instance.respond_to?(:place_changed?) && instance.place_changed?) ||
        (instance.respond_to?(:place_id_changed?) && instance.place_id_changed?)
    }
  end

  def update_location
    self.latitude = place.latitude if place.present?
    self.longitude = place.longitude if place.present?
  end
end
