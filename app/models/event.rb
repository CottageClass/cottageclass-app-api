class Event < ApplicationRecord
  include Eventable

  belongs_to :event_series, inverse_of: :events

  scope :past, -> { where Event.arel_table[:starts_at].lt(Time.current) }
  scope :upcoming, -> { where Event.arel_table[:starts_at].gt(Time.current) }

  delegate :user, to: :event_series, allow_nil: true
  delegate :facebook_uid, :avatar, :first_name, :fuzzy_latitude, :fuzzy_longitude, :locality, :admin_area_level_1,
           :child_ages,
           to: :user, prefix: :host, allow_nil: true
end
