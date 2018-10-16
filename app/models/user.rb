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

  validates :email,
    presence: true,
    uniqueness: true,
    format: {with: /\A.+@.+\..+\z/, message: "Please provide a valid email"}

  has_many :children, class_name: 'Child', inverse_of: :parent
  accepts_nested_attributes_for :children,
    allow_destroy: true,
    reject_if: :child_with_same_name_exists?

  def phone(country_code=false)
    formatted_ph = "(#{phone_area_code}) #{phone_number[0..2]}-#{phone_number[3..-1]}"
    formatted_ph += "+#{phone_country_code} " if country_code
    formatted_ph
  end

  private

  def child_with_same_name_exists?(new_child_attrs)
    parent = self.find(child_attrs[:user_id].to_i)
    child_names = parent.children.pluck(:first_name)
    child_names.include? child_attrs[:first_name]
  end

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
