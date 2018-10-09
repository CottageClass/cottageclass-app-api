class User < ApplicationRecord
  # adds the following:
  # - password must be present on creation
  # - password length must be <= 72bytes
  # - confirmation of password via password_confirmation attribute (if provided in request)
  # - via: https://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html#method-i-has_secure_password
  has_secure_password

  before_validation {
    (self.email = self.email.to_s.downcase)
  }
  before_create {
    populate_full_name!
    populate_fname_from_name!
    populate_lname_from_name!
  }
  # Make sure email is present and unique.
  validates :email, presence: true, uniqueness: true

  private

  def populate_full_name!
    if (!self.name || self.name.length < 1) &&
        (self.first_name && self.first_name.length > 0) &&
        (self.last_name && self.last_name.length > 0)
      self.name = "#{self.first_name} #{self.last_name}"
    end
  end

  def populate_fname_from_name!
    if (self.name && self.name.length > 0) &&
        (!self.first_name || self.first_name.length < 0)
      self.first_name = self.name.split(' ').first
    end
  end

  def populate_lname_from_name!
    if (self.name && self.name.length > 0) &&
        (!self.last_name || self.last_name.length < 0)
      self.last_name = self.name.split(' ').last
    end
  end
end
