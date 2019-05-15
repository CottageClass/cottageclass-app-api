class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  include LegacyPassword

  # Include devise modules. Others available are:
  # :timeoutable, :confirmable, :invitable, :lockable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable,
         :jwt_authenticatable, jwt_revocation_strategy: self, omniauth_providers: %i[facebook]

  attr_accessor :direct

  PUBLIC_ATTRIBUTES = %i[
    id avatar first_name verified fuzzy_latitude fuzzy_longitude locality sublocality neighborhood admin_area_level_1
    admin_area_level_2 images languages job_position employer highest_education school facebook_uid instagram_user
    twitter_user linkedin_user created_at child_ages_in_months profile_blurb activities available_mornings available_afternoons
    available_evenings available_weekends
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

  has_many :stars, class_name: :Star, foreign_key: :giver_id, inverse_of: :giver, dependent: :destroy
  
  has_many :starred_users,        through: :stars, source: :starable, source_type: :User
  has_many :starred_event_series, through: :stars, source: :starable, source_type: :EventSeries
  
  has_many :received_stars, as: :starable, class_name: 'Star', dependent: :destroy, inverse_of: :starable

  accepts_nested_attributes_for :children, allow_destroy: true, reject_if: :child_with_same_name_exists?

  def jwt_payload
    super.merge('user' => CurrentUserSerializer.json_for(self, include: %i[children]))
  end

  def child_ages_in_months
    children.map(&:age_in_months)
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

  def full_address
    [
      [street_number, route].compact.map(&:squish).select(&:present?).join(' '),
      locality,
      admin_area_level_1,
      admin_area_level_2,
      [country, postal_code].compact.map(&:squish).select(&:present?).join(' ')
    ].compact.map(&:squish).select(&:present?).join(', ')
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

  private

  def cleanup
    self.email = email.to_s.downcase
    self.facebook_uid = uid if %w[facebook].include?(provider)
  end

  def notify
    notifications.user_creation.first_or_create
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
