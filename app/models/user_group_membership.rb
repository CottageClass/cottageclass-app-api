class UserGroupMembership < ApplicationRecord
  belongs_to :user, inverse_of: :user_group_memberships, optional: false
  belongs_to :user_group, inverse_of: :user_group_memberships, optional: false

  validates :user_id, presence: true
  validates :user_group_id, presence: true
  validates :user_group_id, uniqueness: { scope: :user_id }
end
