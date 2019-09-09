require 'active_support/concern'

module Eventable
  extend ActiveSupport::Concern

  included do
    before_validation :common_cleanup, :generate_time_zone

    validates :name, presence: true
    validates :starts_at, presence: true
    validates :ends_at, presence: true
    validates :time_zone, presence: true
    validates :maximum_children, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :child_age_minimum, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :child_age_maximum, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

    accepts_nested_attributes_for allow_destroy: true, reject_if: :all_blank
  end

  def in_instance_time_zone(time)
    time_zone.present? ? time.in_time_zone(time_zone) : time
  end

  def common_cleanup
    self.name = name.try :squish
    self.maximum_children ||= 0
    self.child_age_minimum ||= 0
    self.child_age_maximum ||= 0
  end

  def generate_time_zone
    self.time_zone ||= if user.latitude.present? && user.longitude.present?
                         Locator.time_zone_for latitude: user.latitude, longitude: user.longitude
                       end
  end
end
