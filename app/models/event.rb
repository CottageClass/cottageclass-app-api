class Event < ApplicationRecord
  include Eventable

  belongs_to :event_series, inverse_of: :events
  has_many :notifications, as: :notifiable, dependent: :destroy
  has_many :participants, as: :participable, dependent: :destroy
  has_many :participant_children, as: :participable
  has_many :participating_users, through: :participants, source: :user

  scope :past, -> { where(Event.arel_table[:starts_at].lt(Time.current)).order starts_at: :desc }
  scope :upcoming, -> { where(Event.arel_table[:starts_at].gt(Time.current)).order starts_at: :asc }
  scope :notifiable, lambda {
    where(
      Event.arel_table[:ends_at].between(1.hour.ago(Time.current)..1.hour.since(Time.current))
      .or(Event.arel_table[:starts_at].between(1.hour.ago(Time.current)..1.week.since(Time.current)))
    ).order starts_at: :asc
  }

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

  def start_date
    starts_at.strftime('%B %e, %Y').try :squish
  end

  def time_range
    [starts_at.strftime('%l:%M'), ends_at.strftime('%l:%M %p')].join(' - ').try :squish
  end

  def notify
    if ends_at <= Time.current
      # after event has ended
      Notifier::EventFeedbackHost.new(user: user, event: self).transmit
      Notifier::EventCongratulationHost.new(user: user, event: self).transmit
    elsif starts_at <= 1.day.since(Time.current)
      # 24 hours before event will start
      Notifier::EventReminderPreviousDayHost.new(user: user, event: self).transmit
    elsif 1.week.ago(starts_at) <= Time.current
      # 1 week before event will start
      Notifier::EventReminderPreviousWeekHost.new(user: user, event: self).transmit
    end

    if 30.minutes.since(ends_at) <= Time.current
      # 30 minutes after event has ended
      participants.each do |participant|
        Notifier::EventFeedbackParticipant.new(user: participant.user, event: self).transmit
      end
    elsif starts_at <= 2.hours.since(Time.current)
      # 2 hours before event will start
      participants.each do |participant|
        Notifier::EventReminderSameDayParticipant.new(user: participant.user, event: self).transmit
      end
    elsif starts_at <= 1.day.since(Time.current)
      # 24 hours before event will start
      participants.each do |participant|
        Notifier::EventReminderPreviousDayParticipant.new(user: participant.user, event: self).transmit
      end
    end
  end
end
