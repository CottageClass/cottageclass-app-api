class UserMatch < ApplicationRecord
  validates_uniqueness_of :matched_user, scope: :user

  belongs_to :user,
             class_name: 'User',
             foreign_key: :user_id,
             inverse_of: :active_user_matches
  belongs_to :matched_user,
             class_name: 'User',
             foreign_key: :matched_user_id,
             inverse_of: :passive_user_matches
end
