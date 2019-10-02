require 'active_support/concern'

module Eventable
  extend ActiveSupport::Concern

  included do
    before_validation :common_cleanup

    validates :name, presence: true
    validates :starts_at, presence: true
    validates :ends_at, presence: true
    validates :maximum_children, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :child_age_minimum, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :child_age_maximum, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

    accepts_nested_attributes_for allow_destroy: true, reject_if: :all_blank
  end

  def in_instance_time_zone(time)
    place.present? && place.time_zone.present? ? time.in_time_zone(place.time_zone) : time
  end

  def common_cleanup
    self.name = name.try :squish
    self.maximum_children ||= 0
    self.child_age_minimum ||= 0
    self.child_age_maximum ||= 0
  end
end
