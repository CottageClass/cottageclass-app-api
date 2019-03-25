require 'active_support/concern'

module LegacyPassword
  extend ActiveSupport::Concern

  def valid_password?(password)
    if !devise_password? && valid_transitional_password?(password)
      convert_password_to_devise(password)
      return true
    end
    super
  end

  private

  def devise_password?
    encrypted_password.present?
  end

  def valid_transitional_password?(unencrypted_password)
    # check the password against the existing digest
    BCrypt::Password.new(legacy_password_digest).is_password?(unencrypted_password) && self
  end

  def convert_password_to_devise(password)
    # generate an encrypted password using the method used when we create a new user
    new_hashed_password = User.new(password: password).encrypted_password
    self.encrypted_password = new_hashed_password
    save!
  end
end
