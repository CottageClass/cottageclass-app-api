class UserGroup < ApplicationRecord
  has_many :user_group_memberships,
           inverse_of: :user_group,
           foreign_key: :user_group_id
  has_many :members,
           through: :user_group_memberships,
           foreign_key: :user_id,
           source: :user,
           inverse_of: :user_groups
  has_many :comments,
           inverse_of: :group,
           foreign_key: :group_id
end
