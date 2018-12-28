class EventSeries < ApplicationRecord
  include Eventable

  validates :start_date, presence: true
  validates :repeat_for, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :interval, presence: true, numericality: { only_integer: true, greater_than: 0 }

  belongs_to :user, inverse_of: :event_series
  has_many :events, inverse_of: :event_series, dependent: :destroy
  has_many :participants, as: :participable, dependent: :destroy
  has_many :participant_children, as: :participable

  accepts_nested_attributes_for :event_hosts, allow_destroy: true,
                                              reject_if: proc { |attributes| attributes['name'].blank? }

  before_validation :cleanup
  after_create :create_events

  private

  def create_events
    attributes = %i[
      name
      maximum_children
      child_age_minimum
      child_age_maximum
      has_pet
      activity_names
      foods
      house_rules
      pet_description
      event_hosts
    ]
    0.step(by: interval).take(repeat_for).each do |number|
      new_date = number.weeks.since start_date

      event = events.build starts_at: date_time(new_date, starts_at), ends_at: date_time(new_date, ends_at)
      attributes.each { |attribute| event.send format('%s=', attribute), send(attribute) }
      event.save
    end
  end

  def date_time(date, time)
    Time.zone.parse format('%s %s', date.strftime('%F'), time.strftime('%T'))
  end

  def cleanup
    self.repeat_for ||= 6
    self.interval ||= 4
  end
end
