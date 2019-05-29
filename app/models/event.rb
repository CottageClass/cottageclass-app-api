class Event < ApplicationRecord
  include Eventable

  PAST_PENALTY = 31_557_600 # seconds in a year
  enum kind: { manual: 0, generated: 1 }

  geocoded_by :host_full_address

  before_validation :cleanup
  after_validation :geocode, if: lambda { |instance|
    instance.host_full_address.present? && (instance.latitude.blank? || instance.longitude.blank?)
  }
  after_create :notify_creation
  after_create :set_recency
  before_destroy :notify_participants_destruction

  belongs_to :event_series, inverse_of: :events
  has_one :user, through: :event_series, inverse_of: :events
  has_many :notifications, as: :notifiable, dependent: :nullify
  has_many :user_reviews, as: :reviewable, dependent: :nullify
  has_many :participants, as: :participable, dependent: :destroy
  has_many :participant_children, as: :participable
  has_many :participating_users, through: :participants, source: :user

  scope :eager, -> { includes :event_hosts, participants: %i[user participant_children] }
  scope :nearest, ->(user) { where.not(id: user.events).near([user.latitude, user.longitude], 100) }
  scope :past, -> { where(Event.arel_table[:starts_at].lt(Time.current)).order starts_at: :desc }
  scope :upcoming, -> { where(Event.arel_table[:starts_at].gteq(1.hour.ago(Time.current))).order starts_at: :asc }
  scope :notifiable, lambda {
    where(
      Event.arel_table[:ends_at].between(1.hour.ago(Time.current)..1.hour.since(Time.current))
      .or(Event.arel_table[:starts_at].between(1.hour.ago(Time.current)..1.week.since(Time.current)))
    ).order starts_at: :asc
  }

  delegate(*User::PUBLIC_ATTRIBUTES, to: :user, prefix: :host, allow_nil: true)
  delegate :first_name, :full_address, to: :user, prefix: :host, allow_nil: true

  def full?
    maximum_children.positive? && (participant_children.count >= maximum_children)
  end

  def participated?(user)
    user.present? ? participating_users.include?(user) : false
  end

  def start_date
    in_instance_time_zone(starts_at).strftime('%B %e, %Y').try :squish
  end

  def time_range
    [in_instance_time_zone(starts_at).strftime('%l:%M'), in_instance_time_zone(ends_at).strftime('%l:%M %p')]
      .join(' - ').try :squish
  end

  def update_recency_score
    seconds_since_created = (Time.current - created_at) / 1.second
    past = (ends_at < Time.current + 2.hours)
    update_column :recency_score, seconds_since_created + (past ? PAST_PENALTY : 0)
  end

  def notify
    if participants.any?
      if ends_at <= Time.current
        # after event has ended
        notifications.event_feedback_host.where(recipient: user).first_or_create
        notifications.event_congratulation_host.where(recipient: user).first_or_create
      elsif starts_at <= 1.day.since(Time.current)
        # 24 hours before event will start
        notifications.event_reminder_previous_day_host.where(recipient: user).first_or_create
      elsif 1.week.ago(starts_at) <= Time.current
        # 1 week before event will start
        notifications.event_reminder_previous_week_host.where(recipient: user).first_or_create
      end
    end

    if 30.minutes.since(ends_at) <= Time.current
      # 30 minutes after event has ended
      participants.each do |participant|
        notifications.event_feedback_participant.where(recipient: participant.user).first_or_create
      end
    elsif starts_at <= 2.hours.since(Time.current)
      # 2 hours before event will start
      participants.each do |participant|
        notifications.event_reminder_same_day_participant.where(recipient: participant.user).first_or_create
      end
    elsif starts_at <= 1.day.since(Time.current)
      # 24 hours before event will start
      participants.each do |participant|
        notifications.event_reminder_previous_day_participant.where(recipient: participant.user).first_or_create
      end
    end
  end

  private

  def set_recency
    update_recency_score
    host.update_showcase_event
  end

  def notify_creation
    notifications.event_creation_host.where(recipient: user).first_or_create if generated?
  end

  def notify_participants_destruction
    participants.each do |participant|
      participant.user.notifications.event_destruction.where(notifiable: self).first_or_create
    end
  end

  def cleanup
    self.latitude = user.try(:latitude) unless latitude.present? && latitude.nonzero?
    self.longitude = user.try(:longitude) unless longitude.present? && longitude.nonzero?
  end
end
