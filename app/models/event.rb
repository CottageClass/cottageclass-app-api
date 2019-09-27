class Event < ApplicationRecord
  include Eventable
  include Starable

  PAST_PENALTY = 31_557_600 # seconds in a year

  geocoded_by :host_full_address

  before_validation :cleanup
  after_validation :geocode, if: lambda { |instance|
    instance.host_full_address.present? && (instance.latitude.blank? || instance.longitude.blank?)
  }
  after_create :post_create
  before_destroy :notify_participants_destruction
  before_destroy :remove_user_showcase
  after_destroy :update_user_showcase

  belongs_to :event_series, inverse_of: :events
  has_one :place,
          through: :event_series,
          inverse_of: :events,
          dependent: :destroy
  has_one :user, through: :event_series, inverse_of: :events
  has_one :search_list_item, as: :itemable, class_name: 'SearchListItem', dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :nullify
  has_many :participants, as: :participable, dependent: :destroy
  has_many :participant_children, as: :participable
  has_many :participating_users, through: :participants, source: :user

  scope :has_participants, -> { joins(:participants) }
  scope :eager, -> { includes participants: %i[user participant_children] }
  scope :nearest, ->(user) { where.not(id: user.events).near([user.latitude, user.longitude], 100) }
  scope :past, -> { where(Event.arel_table[:starts_at].lt(Time.current)).order starts_at: :desc }
  scope :upcoming, -> { where(Event.arel_table[:starts_at].gteq(1.hour.ago(Time.current))).order starts_at: :asc }
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

  def full?
    maximum_children.positive? && (participant_children.count >= maximum_children)
  end

  def participated?(user)
    user.present? ? participating_users.include?(user) : false
  end

  def month_abbreviated
    in_instance_time_zone(starts_at).strftime('%b').try :squish
  end

  def day_of_month
    in_instance_time_zone(starts_at).strftime('%e').try :squish
  end

  def start_time_hour
    in_instance_time_zone(starts_at).strftime('%l%p').try :squish
  end

  def start_date
    in_instance_time_zone(starts_at).strftime('%B %e, %Y').try :squish
  end

  def start_day
    in_instance_time_zone(starts_at).strftime('%A').try :squish
  end

  def time_range
    [in_instance_time_zone(starts_at).strftime('%l:%M'), in_instance_time_zone(ends_at).strftime('%l:%M %p')]
      .join(' - ').try :squish
  end

  def end_time
    in_instance_time_zone(ends_at).strftime('%l:%M')
  end

  def start_time
    in_instance_time_zone(starts_at).strftime('%l:%M %P')
  end

  def update_recency_score
    seconds_since_created = (Time.current - created_at) / 1.second
    past = (ends_at < Time.current + 1.hour)
    update_column :recency_score, seconds_since_created + (past ? PAST_PENALTY : 0)
  end

  class << self
    def batch_event_job(last_run_time)
      recent_events = Event.joins(:event_series).includes(:user).where('events.created_at > ?', last_run_time).to_a

      hosts = recent_events.map(&:user).uniq
      hosts.each do |host|
        # find all the starrers of the hosts an send an email
        starrers = User
          .joins('INNER JOIN stars ON users.id = stars.giver_id')
          .where("stars.starable_type = 'User' AND stars.starable_id = ?", host.id)
        starrers.each do |starrer|
          starrer.notify_event_creation_starrer host if starrer.id != host.id
        end

        nearby_users = users_with_distance
          .from(users_with_distance, :users)
          .near([host.latitude, host.longitude], :setting_max_distance)
          .where.not(id: host.id)

        recipients = []
        host.children.each do |child|
          eligible_users_for_child = nearby_users.child_birthday_range(child.birthday - 2.years.seconds,
                                                                       child.birthday + 2.years.seconds)
          recipients += eligible_users_for_child.to_a
          recipients = recipients.uniq
        end
        # User.all.each do |recipient|
        recipients.each do |recipient|
          recipient.notify_event_creation_match host unless starrers.include? recipient
          next if recipient.devices.empty?

          push_notification = Rpush::Gcm::Notification.new
          push_notification.app = Rpush::Gcm::App.find_by(name: 'lilypad')
          push_notification.registration_ids = recipient.devices.pluck(:token)
          push_notification.data = {
            icon: host.avatar,
            url: ENV['LINK_HOST'] + '/event/' + recent_events.first.id.to_s,
            title: "#{host.first_name.capitalize} has a new offering",
            body: recent_events.first.name
          }
          push_notification.save!
        end
      end
    end
  end

  def notify
    if participants.any?
      if ends_at <= Time.current
        # after event has ended
        notifications.event_feedback_host.where(recipient: user).first_or_create
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

  def remove_user_showcase
    user.update_column :showcase_event_id, nil if user.showcase_event.try(:id) == id
  end

  def update_user_showcase
    user.update_showcase_event
  end

  def create_search_list_item
    SearchListItem.create(user: user, itemable: self)
  end

  def post_create
    update_recency_score
    update_user_showcase
    create_search_list_item
  end

  def notify_participants_destruction
    past = (ends_at < Time.current + 1.hour)
    unless past
      participants.each do |participant|
        participant.user.notifications.event_destruction.where(notifiable: self).first_or_create
      end
    end
  end

  def cleanup
    self.latitude = user.try(:latitude) unless latitude.present? && latitude.nonzero?
    self.longitude = user.try(:longitude) unless longitude.present? && longitude.nonzero?
  end
end
