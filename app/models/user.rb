class User < ApplicationRecord
  # adds the following:
  # - password must be present on creation
  # - password length must be <= 72bytes
  # - confirmation of password via password_confirmation attribute (if provided in request)
  # - via: https://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html#method-i-has_secure_password
  has_secure_password

  attr_accessor :direct

  alias_attribute :facebook_id, :facebook_uid

  before_validation do
    self.email = email.to_s.downcase
    self.network_code = network_code.to_s.downcase
  end
  before_create do
    populate_full_name!
    populate_fname_from_name!
    populate_lname_from_name!
  end

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
  has_many :sent_messages, class_name: 'Message', foreign_key: :sender_id, inverse_of: :sender
  has_many :received_messages, class_name: 'Message', foreign_key: :receiver_id, inverse_of: :receiver
  has_many :inquirers, -> { distinct }, through: :received_messages, source: :sender
  has_many :initiated_sessions, class_name: 'TwilioSession', foreign_key: :sender_id, inverse_of: :initiator
  has_many :client_sessions, class_name: 'TwilioSession', foreign_key: :receiver_id, inverse_of: :client
  has_many :event_series, inverse_of: :user, dependent: :destroy
  has_many :events, through: :event_series

  accepts_nested_attributes_for :children,
                                allow_destroy: true,
                                reject_if: :child_with_same_name_exists?

  scope :in_network, ->(code) { where network_code: code }

  def child_ages
    children.map(&:age)
  end

  def fuzzy_latitude
    latitude
  end

  def fuzzy_longitude
    longitude
  end

  def phone(country_code = false)
    return nil if phone_number.blank?

    formatted_ph = "(#{phone_area_code}) #{phone_number[0..2]}-#{phone_number[3..-1]}"
    formatted_ph = "+#{phone_country_code} #{formatted_ph}" if country_code
    formatted_ph
  end

  def full_address
    admin_area_level_2_str = admin_area_level_2 ? ", #{admin_area_level_2}" : ''

    "#{street_number} #{route}, #{locality}, #{admin_area_level_1}#{admin_area_level_2_str}, #{country} #{postal_code}"
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

  def child_with_same_name_exists?(new_child_attrs)
    child_names = children.pluck(:first_name)
    child_names.include? new_child_attrs[:first_name]
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
