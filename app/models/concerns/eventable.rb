require 'active_support/concern'

module Eventable
  extend ActiveSupport::Concern

  included do
    validates :name, presence: true
    validates :starts_at, presence: true
    validates :ends_at, presence: true
    validates :maximum_children, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :child_age_minimum, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :child_age_maximum, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

    has_and_belongs_to_many :event_hosts

    before_validation :common_cleanup
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
end
