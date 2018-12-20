class EventSeries < ApplicationRecord
  validates :name, presence: true
  validates :start_date, presence: true
  validates :starts_at, presence: true
  validates :ends_at, presence: true
  validates :repeat_for, presence: true
  validates :interval, presence: true

  belongs_to :user, inverse_of: :event_series
  has_many :events, inverse_of: :event_series, dependent: :destroy
  has_and_belongs_to_many :event_hosts

  accepts_nested_attributes_for :event_hosts, allow_destroy: true,
                                              reject_if: proc { |attributes| attributes['name'].blank? }

  before_validation :cleanup
  after_create :create_events

  private

  def create_events
    0.step(by: interval).take(repeat_for).each do |number|
      new_date = number.weeks.since start_date
      events.create name: name, starts_at: date_time(new_date, starts_at), ends_at: date_time(new_date, ends_at)
    end
  end

  def date_time(date, time)
    Time.zone.parse format('%s %s', date.strftime('%F'), time.strftime('%T'))
  end

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
