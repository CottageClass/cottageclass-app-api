class User < ApplicationRecord
  # adds the following:
  # - password must be present on creation
  # - password length must be <= 72bytes
  # - confirmation of password via password_confirmation attribute (if provided in request)
  # - via: https://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html#method-i-has_secure_password
  has_secure_password

  attr_accessor :direct

  alias_attribute :facebook_id, :facebook_uid

  PUBLIC_ATTRIBUTES = %i[
    id facebook_uid avatar first_name verified fuzzy_latitude fuzzy_longitude locality sublocality neighborhood
    admin_area_level_1 admin_area_level_2 child_ages created_at
  ].freeze

  before_validation :cleanup
  after_validation :geocode, if: lambda { |instance|
    instance.full_address.present? && (instance.latitude.blank? || instance.longitude.blank?)
  }
  before_save :obfuscate_location, :generate_time_zone,
              if: proc { |instance| instance.latitude_changed? || instance.longitude_changed? }
  before_create do
    populate_full_name!
    populate_fname_from_name!
    populate_lname_from_name!
  end
  after_create :notify

  geocoded_by :full_address

  with_options if: proc { |instance| instance.direct == true } do
    validates :password, presence: true
    validates :first_name, presence: true
    validates :last_name, presence: true
  end
  validates :email,
            presence: true,
            uniqueness: true,
            format: { with: /\A.+@.+\..+\z/, message: 'Please provide a valid email' }

  has_many :children, class_name: 'Child', foreign_key: :parent_id, inverse_of: :parent, dependent: :destroy
  has_many :sent_messages, class_name: 'Message', foreign_key: :sender_id, inverse_of: :sender, dependent: :destroy
  has_many :received_messages, class_name: 'Message', foreign_key: :receiver_id, inverse_of: :receiver,
                               dependent: :destroy
  has_many :inquirers, -> { distinct }, through: :received_messages, source: :sender
  has_many :initiated_sessions, class_name: 'TwilioSession', foreign_key: :sender_id, inverse_of: :initiator,
                                dependent: :destroy
  has_many :client_sessions, class_name: 'TwilioSession', foreign_key: :receiver_id, inverse_of: :client,
                             dependent: :destroy
  has_many :event_series, inverse_of: :user, dependent: :destroy
  has_many :events, through: :event_series, inverse_of: :user
  has_many :participants, inverse_of: :user, dependent: :destroy
  has_many :participated_events, through: :participants, source: :participable, source_type: 'Event'
  has_many :notifications, foreign_key: :recipient_id, inverse_of: :recipient, dependent: :destroy
  has_many :user_reviews, inverse_of: :user, dependent: :destroy
  has_many :reviewed_users, class_name: 'UserReview', foreign_key: :reviewer_id, inverse_of: :reviewer,
                            dependent: :destroy

  accepts_nested_attributes_for :children, allow_destroy: true, reject_if: :child_with_same_name_exists?

  scope :in_network, ->(code) { where network_code: code }

  def child_ages
    children.map(&:age)
  end

  def child_names
    children.map(&:first_name)
  end

  def phone(country_code = false)
    return nil if phone_number.blank?

    Phony.format [phone_country_code, phone_area_code, phone_number].join(''),
                 format: (false.eql?(country_code) ? :national : :international)
  end

  def full_address
    [
      [street_number, route].compact.map(&:squish).select(&:present?).join(' '),
      locality,
      admin_area_level_1,
      admin_area_level_2,
      [country, postal_code].compact.map(&:squish).select(&:present?).join(' ')
    ].compact.map(&:squish).select(&:present?).join(', ')
  end

  def facebook_token_expired?
    # fb_access_token_expires_at is a DateTime, so use DateTime to compare
    !facebook_access_token || (DateTime.now.utc > fb_access_token_expires_at.utc)
  end

  def facebook_token_invalid?
    !facebook_access_token || facebook_token_expired? || !FacebookService.valid_token?(facebook_access_token)
  end

  # facebook_access_token is a database attr
  def refresh_facebook_access_token!
    if facebook_token_invalid?
      token_info = FacebookService.refresh_access_token_info(facebook_access_token)
      access_token = token_info['access_token']
      sec_til_expiry = token_info['expires_in'].to_i

      update_facebook_access_token!(access_token, sec_til_expiry)
    end
  end

  def update_facebook_access_token!(new_access_token, sec_til_expiry)
    update! facebook_access_token: new_access_token,
            fb_access_token_expires_at: (Time.now.utc + sec_til_expiry).to_datetime
  end

  private

  def cleanup
    self.email = email.to_s.downcase
    self.network_code = network_code.to_s.downcase
  end

  def notify
    notifications.user_creation.where(recipient: self).first_or_create
  end

  def obfuscate_location
    location = if (latitude.present? && latitude.nonzero?) && (longitude.present? && longitude.nonzero?)
                 # update dependent events
                 events.update_all latitude: latitude, longitude: longitude

                 Locator.obfuscate latitude: latitude, longitude: longitude
               else
                 { fuzzy_latitude: nil, fuzzy_longitude: nil }
               end
    assign_attributes location
  end

  def generate_time_zone
    self.time_zone = if (latitude.present? && latitude.nonzero?) && (longitude.present? && longitude.nonzero?)
                       Locator.time_zone_for latitude: latitude, longitude: longitude
                     end
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
