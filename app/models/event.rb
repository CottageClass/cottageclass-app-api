class Event < ApplicationRecord
  include Eventable

  belongs_to :event_series, inverse_of: :events
  has_many :participants, as: :participable, dependent: :destroy
  has_many :participant_children, as: :participable
  has_many :participating_users, through: :participants, source: :user

  scope :past, -> { where(Event.arel_table[:starts_at].lt(Time.current)).order starts_at: :desc }
  scope :upcoming, -> { where(Event.arel_table[:starts_at].gt(Time.current)).order starts_at: :asc }

  delegate :user, to: :event_series, allow_nil: true
  delegate :id, :facebook_uid, :avatar, :first_name, :fuzzy_latitude, :fuzzy_longitude, :locality, :sublocality,
           :neighborhood, :admin_area_level_1, :admin_area_level_2, :child_ages, :verified,
           to: :user, prefix: :host, allow_nil: true

  def full?
    maximum_children.positive? && (participant_children.count >= maximum_children)
  end

  def participated?(user)
    user.present? ? participating_users.include?(user) : false
  end
end
