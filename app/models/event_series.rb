class EventSeries < ApplicationRecord
  include Eventable
  include Locatable

  validates :start_date, presence: true
  validates :repeat_for, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :interval, presence: true, numericality: { only_integer: true, greater_than: 0 }

  belongs_to :user, inverse_of: :event_series
  belongs_to :place, inverse_of: :event_series, optional: true
  has_many :events, inverse_of: :event_series, dependent: :destroy

  before_validation :cleanup
  after_create :set_users_home
  after_save :create_events

  accepts_nested_attributes_for :place

  private

  def validate_associated_records_for_place
    return if place.blank?

    if new_place = Place.find_by(google_id: place.google_id, apartment_number: place.apartment_number)
      self.place = new_place
    else
      place.save!
    end
  end

  def set_users_home
    # if no place has been set, use the creators home
    place ||= user.place
  end

  def create_events
    0.step(by: interval).take(repeat_for).each { |number| create_event new_date: number.weeks.since(start_date) }
  end

  def create_event(new_date:)
    event = events.build starts_at: date_time(new_date, starts_at), ends_at: date_time(new_date, ends_at)
    %i[
      name
      images
      description
      maximum_children
      child_age_minimum
      child_age_maximum
    ].each { |attribute| event.send format('%s=', attribute), send(attribute) }
    event.save
  end

  def date_time(date, time)
    if place&.time_zone.present?
      Time.use_zone(place.time_zone) { Time.zone.parse format('%s %s', date.strftime('%F'), time.strftime('%T')) }
    end
  end

  def cleanup
    self.repeat_for ||= 6
    self.interval ||= 4
  end
end
