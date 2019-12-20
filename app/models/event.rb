class Event < ApplicationRecord
  include Eventable
  include Starable
  include Locatable

  PAST_PENALTY = 31_557_600 # seconds in a year

  after_create :add_host_participant
  before_destroy :notify_participants_destruction

  belongs_to :event_series, inverse_of: :events
  has_one :place,
          through: :event_series,
          inverse_of: :events,
          dependent: :destroy
  has_one :user, through: :event_series, inverse_of: :events
  has_many :notifications, as: :notifiable, dependent: :nullify
  has_many :participants, as: :participable, dependent: :destroy
  has_many :participating_users, through: :participants, source: :user
  has_many :event_collection_memberships, dependent: :destroy
  has_many :event_collections, through: :event_collection_memberships

  scope :has_participants, -> { joins(:participants) }
  scope :eager, -> { includes participants: %i[user] }
  scope :nearest, ->(user) { where.not(id: user.events).near([user.place.latitude, user.place.longitude], 100) }
  scope :past, -> { where(Event.arel_table[:starts_at].lt(Time.current)).order starts_at: :desc }
  scope :upcoming, -> { where(Event.arel_table[:starts_at].gteq(1.hour.ago(Time.current))).order starts_at: :asc }
  scope :next_day, lambda {
                     where(Event.arel_table[:starts_at].gteq(1.hour.ago(Time.current)))
                       .where(Event.arel_table[:starts_at].lteq(1.day.since(Time.current)))
                   }
  scope :notifiable, lambda {
    where(
      Event.arel_table[:ends_at].between(1.hour.ago(Time.current)..1.hour.since(Time.current))
      .or(Event.arel_table[:starts_at].between(1.hour.ago(Time.current)..1.week.since(Time.current)))
    ).order starts_at: :asc
  }

  def self.ransackable_scopes(_auth_object = nil)
    %i[has_participants upcoming]
  end

  delegate(*User::PUBLIC_ATTRIBUTES, to: :user, prefix: :host, allow_nil: true)
  delegate :first_name, :full_address, to: :user, prefix: :host, allow_nil: true

  def participated?(user)
    user.present? ? participating_users.include?(user) : false
  end

  def month_abbreviated
    in_instance_time_zone(starts_at).strftime('%b').try :squish
  end

  def day_of_month
    in_instance_time_zone(starts_at).strftime('%e').try :squish
  end

  def start_date
    in_instance_time_zone(starts_at).strftime('%B %e, %Y').try :squish
  end

  def start_date_abbreviated_short_month
    in_instance_time_zone(starts_at).strftime('%b %-e').try :squish
  end

  def image
    if images.present?
      images[0]
    elsif place.images.present?
      place.images[0]
    else
      user.avatar
    end
  end

  def start_date_abbreviated
    in_instance_time_zone(starts_at).strftime('%-m/%-e').try :squish
  end

  def start_day
    in_instance_time_zone(starts_at).strftime('%A').try :squish
  end

  def start_day_abbreviated
    in_instance_time_zone(starts_at).strftime('%a').try :squish
  end

  def time_range
    [in_instance_time_zone(starts_at).strftime('%l:%M %p'), in_instance_time_zone(ends_at).strftime('%l:%M %p')]
      .join(' - ').try :squish
  end

  def end_time
    in_instance_time_zone(ends_at).strftime('%l:%M %P')
  end

  def start_time
    in_instance_time_zone(starts_at).strftime('%l:%M %P')
  end

  def notify
    non_hosts = participants.reject do |p|
      p.user == user
    end
    if non_hosts.any? && !place.public
      if starts_at <= 1.day.since(Time.current) && user.setting_notify_event_reminder_email
        # 24 hours before event will start

        notifications.event_reminder_previous_day_host.where(recipient: user).first_or_create
      elsif 1.week.ago(starts_at) <= Time.current && user.setting_notify_event_reminder_sms
        # 1 week before event will start

        notifications.event_reminder_previous_week_host.where(recipient: user).first_or_create
      end
    end

    if starts_at <= 2.hours.since(Time.current)
      # 2 hours before event will start
      non_hosts.each do |participant|
        next unless participant.user.setting_notify_event_reminder_sms

        notifications.event_reminder_same_day_participant.where(recipient: participant.user).first_or_create
      end
    elsif starts_at <= 1.day.since(Time.current)
      # 24 hours before event will start
      non_hosts.each do |participant|
        next unless participant.user.setting_notify_event_reminder_sms

        notifications.event_reminder_previous_day_participant.where(recipient: participant.user).first_or_create
      end
    end
  end

  private

  def add_host_participant
    host_participant = participants.build user: user
    host_participant.save
    save!
  end

  def notify_participants_destruction
    past = (ends_at < Time.current + 1.hour)
    unless past
      participants.each do |participant|
        participant.user.notifications.event_destruction.where(notifiable: self).first_or_create
      end
    end
  end
end
