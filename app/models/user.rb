class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  include LegacyPassword
  include Starable
  include Locatable

  # Include devise modules. Others available are:
  # :timeoutable, :confirmable, :invitable, :lockable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable,
         :jwt_authenticatable, jwt_revocation_strategy: self, omniauth_providers: %i[facebook]

  attr_accessor :direct, :token

  PUBLIC_ATTRIBUTES = %i[
    id avatar first_name verified images languages job_position employer highest_education facebook_uid
    created_at child_ages_in_months profile_blurb activities available_mornings
    available_afternoons available_evenings available_weekends
  ].freeze

  after_update :sms_notify
  before_save :add_to_groups, if: lambda { |instance|
    (instance.respond_to?(:place_changed?) && instance.place_changed?) ||
      (instance.respond_to?(:place_id_changed?) && instance.place_id_changed?)
  }

  before_validation :cleanup
  before_create do
    populate_full_name!
    populate_fname_from_name!
    populate_lname_from_name!
  end

  after_create :notify

  with_options if: proc { |instance| instance.direct == true } do
    validates :password, presence: true
    validates :first_name, presence: true
    validates :last_name, presence: true
  end
  validates :email,
            presence: true,
            uniqueness: true,
            format: { with: /\A.+@.+\..+\z/, message: 'Please provide a valid email' }

  has_many :place_reviews,
           inverse_of: :user

  has_many :received_conversations,
           inverse_of: :recipient,
           class_name: 'Conversation',
           foreign_key: :recipient_id,
           dependent: :nullify
  has_many :initiated_conversations,
           inverse_of: :initiator,
           class_name: 'Conversation',
           foreign_key: :initiator_id,
           dependent: :nullify

  has_many :comments,
           foreign_key: :sender_id,
           inverse_of: :sender,
           dependent: :destroy
  has_many :user_group_memberships,
           inverse_of: :user,
           dependent: :destroy
  has_many :user_groups,
           through: :user_group_memberships

  has_many :created_places,
           inverse_of: :creator,
           class_name: 'Place',
           foreign_key: :user_id,
           dependent: :nullify
  has_many :devices, dependent: :nullify
  has_many :children,
           class_name: 'Child',
           foreign_key: :parent_id,
           inverse_of: :parent,
           dependent: :destroy

  has_many :sent_messages, class_name: 'Message', foreign_key: :sender_id, inverse_of: :sender, dependent: :nullify
  has_many :received_messages, class_name: 'Message', foreign_key: :receiver_id, inverse_of: :receiver,
                               dependent: :nullify
  has_many :event_series, inverse_of: :user, dependent: :destroy
  has_many :events, through: :event_series, inverse_of: :user
  has_many :participants, inverse_of: :user, dependent: :destroy
  has_many :participated_events, through: :participants, source: :participable, source_type: 'Event'
  has_many :notifications, foreign_key: :recipient_id, inverse_of: :recipient, dependent: :destroy

  has_many :stars, class_name: 'Star', foreign_key: :giver_id, inverse_of: :giver, dependent: :destroy
  has_many :dark_stars, class_name: 'DarkStar', foreign_key: :giver_id, inverse_of: :giver, dependent: :destroy

  has_many :starred_users,        through: :stars, source: :starable, source_type: :User
  has_many :dark_starred_users,   through: :dark_stars, source: :recipient
  has_many :received_dark_stars,
           class_name: 'DarkStar',
           foreign_key: :recipient,
           inverse_of: :recipient,
           dependent: :destroy

  belongs_to :place, inverse_of: :users, optional: true, autosave: true

  accepts_nested_attributes_for :children, allow_destroy: true, reject_if: :child_with_same_name_exists?
  accepts_nested_attributes_for :place

  scope :child_age_range, lambda { |min_age, max_age|
    if min_age.present? || max_age.present?
      min_age ||= 0
      min_age = min_age.to_i
      max_age ||= 17
      max_age = max_age.to_i
      earliest_birthday = (Time.current - (max_age + 1).year.seconds)
      latest_birthday = (Time.current - min_age.year.seconds)
      time_range = earliest_birthday..latest_birthday
      joins(:children).where('children.birthday' => time_range)
    end
  }
  scope :child_birthday_range, lambda { |earliest, latest|
    if earliest.present? || latest.present?
      earliest ||= Time.current - 20.years.seconds
      latest ||= Time.current
      time_range = earliest..latest
      joins(:children).where('children.birthday' => time_range)
    end
  }

  def jwt_payload
    super.merge('user' => CurrentUserSerializer.json_for(self,
                                                         include: %i[children place],
                                                         params: { current_users_place: true }))
  end

  def last_initial
    last_name.slice(0).upcase
  end

  def child_ages_in_months
    @child_ages_in_months ||= children.map(&:age_in_months)
  end

  def child_names
    children.map(&:first_name)
  end

  def phone(country_code = false)
    return nil if phone_number.blank?

    Phony.format [phone_country_code, phone_area_code, phone_number].join(''),
                 format: (false.eql?(country_code) ? :national : :international)
  end

  def nearest_upcoming_event
    Event.upcoming.nearest(self).reorder('distance ASC').order(starts_at: :asc).first
  end

  class << self
    def from_omniauth(auth)
      # [suman] This mechanism works for the Facebook payload, and may need adjustment for other providers.
      instance = find_by email: auth.info.email
      if instance.blank?
        instance = where(provider: auth.provider, uid: auth.uid).first_or_initialize \
          email: auth.info.email,
          password: Devise.friendly_token(12),
          name: auth.info.name,
          facebook_access_token: auth.credentials.token
        if instance.new_record?
          instance.skip_confirmation! if User.confirmable?
          instance.save
        end
      else
        instance.update provider: auth.provider, uid: auth.uid
      end
      instance
    end

    def confirmable?
      Devise.mappings[:user].confirmable?
    end
  end

  def either_dark_star?(other_user)
    dark_star = DarkStar.where(giver: self, recipient: other_user)
    return true if dark_star.count > 0

    dark_star = DarkStar.where(giver: other_user, recipient: self)
    return true if dark_star.count > 0

    false
  end

  def push_to_devices(data)
    devices.each do |d|
      d.send_push(data)
    end
  end

  def push_notify_new_group_chat(comment)
    return unless setting_notify_group_messages_push

    push_to_devices icon: comment.sender.avatar,
                    url: ENV['LINK_HOST'] + '/group-chat/' + comment.group.id.to_s,
                    title: "#{comment.sender.first_name.capitalize} sent a new  message to #{comment.group.name}",
                    body: 'Tap to read the message and respond'
  end

  def push_notify_message_receipt(message)
    return unless setting_notify_messages_push

    push_to_devices icon: message.sender.avatar,
                    url: ENV['LINK_HOST'] + '/chat/' + message.sender.id.to_s,
                    title: "New message from #{message.sender.first_name.capitalize}",
                    body: 'Tap to read the message and respond'
  end

  def push_notify_event_creation(event)
    push_to_devices icon: event.user.avatar,
                    url: ENV['LINK_HOST'] + '/event/' + event.id.to_s,
                    title: "#{event.user.first_name.capitalize} has a new offering",
                    body: event.name
  end

  def notify_event_creation_match(host)
    return unless setting_email_notifications

    today_notifications = notifications.event_creation_match.where created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day
    notifications.event_creation_match.create(notifiable: host) if today_notifications.empty?
  end

  def notify_event_creation_starrer(host)
    return unless setting_email_notifications

    puts "sending a starrer message to #{id} about #{host.id}"
    notifications.event_creation_starrer.create(notifiable: host)
  end

  def notify_daily_digest
    return unless setting_email_notifications

    miles = setting_max_distance || 10

    nearby_place_ids = Place.near(place, miles).to_a.pluck :id
    events = Event.joins(:event_series).next_day.where('event_series.place_id IN (?)', nearby_place_ids)
    events = events.where('event_series.user_id <> ?', id)
    return if events.empty?

    notifiable_event_collection = EventCollection.create
    notifiable_event_collection.events = events
    notifiable_event_collection.save

    notifications.daily_digest.where(notifiable: notifiable_event_collection).create
  end

  def send_reset_password_instructions_notification(token)
    @token = token
    notifications.password_reset_request.create if token.present?
  end

  private

  def add_to_groups
    existing_membership = user_group_memberships.find_by(user_group_id: 1)

    worcester = [42.2626, -71.8023]
    worcester_group = UserGroup.find_by(id: 1)
    return if worcester_group.nil? || place.nil?

    if (distance_to worcester) <= 20 && existing_membership.nil?
      user_groups << worcester_group
      save!
    end

    existing_membership.destroy if (distance_to worcester) > 20 && existing_membership.present?
  end

  def validate_associated_records_for_place
    return if place.blank?

    new_place = Place.where(google_id: place.google_id).find_by(apartment_number: place.apartment_number)
    if new_place
      self.place = new_place
    else
      place.save!
    end
  end

  def cleanup
    self.email = email.to_s.downcase
    self.facebook_uid = uid if %w[facebook].include?(provider)
  end

  def sms_notify
    notifications.user_sms_welcome.first_or_create if phone_number.present?
  end

  def notify
    notifications.user_creation.first_or_create
  end

  def child_with_same_name_exists?(child_attributes)
    if new_record?
      child_names.include? child_attributes[:first_name]
    else
      false
    end
  end

  def populate_full_name!
    self.name = [first_name, last_name].join(' ') if name.blank? && first_name.present? && last_name.present?
  end

  def populate_fname_from_name!
    self.first_name = name.split(' ').first if name.present? && first_name.blank?
  end

  def populate_lname_from_name!
    self.last_name = name.split(' ').last if name.present? && last_name.blank?
  end
end
