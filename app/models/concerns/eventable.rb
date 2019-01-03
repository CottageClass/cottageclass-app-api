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

    has_and_belongs_to_many :event_hosts

    accepts_nested_attributes_for :event_hosts, allow_destroy: true,
                                                reject_if: proc { |attributes| attributes['name'].blank? }
  end

  def with_instance_time_zone
    Time.use_zone(time_zone) { yield } if block_given? && time_zone.present?
  end

  def common_cleanup
    self.name = name.try :squish
    self.maximum_children ||= 0
    self.child_age_minimum ||= 0
    self.child_age_maximum ||= 0
    self.house_rules = house_rules.try :squish
    self.pet_description = has_pet? ? pet_description.try(:squish) : nil
    self.activity_names = activity_names.map(&:squish).select(&:present?)
    self.foods = foods.map(&:squish).select(&:present?)
  end

  def generate_time_zone
    self.time_zone ||= if user.latitude.present? && user.longitude.present?
                         Locator.time_zone_for latitude: user.latitude, longitude: user.longitude
                       end
  end
end
