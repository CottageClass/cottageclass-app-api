class EventSeries < ApplicationRecord
  validates :name, presence: true
  validates :start_date, presence: true
  validates :starts_at, presence: true
  validates :ends_at, presence: true
  validates :repeat_for, presence: true
  validates :interval, presence: true

  belongs_to :user, inverse_of: :event_series
  has_and_belongs_to_many :event_hosts

  accepts_nested_attributes_for :event_hosts, allow_destroy: true,
                                              reject_if: proc { |attributes| attributes['name'].blank? }

  before_validation :cleanup

  private

  def cleanup
    self.name = name.try :squish
    self.repeat_for ||= 6
    self.interval ||= 4
    self.house_rules = house_rules.try :squish
    self.pet_description = has_pet? ? pet_description.try(:squish) : nil
    self.activity_names = activity_names.map(&:squish).select(&:present?)
    self.foods = foods.map(&:squish).select(&:present?)
  end
end
