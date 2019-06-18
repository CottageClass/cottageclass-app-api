class UserMatch < ApplicationRecord
  validates_uniqueness_of :matched_user, scope: :user

  belongs_to :user
  belongs_to :matched_user, class_name: 'User', inverse_of: :matched_users
end
