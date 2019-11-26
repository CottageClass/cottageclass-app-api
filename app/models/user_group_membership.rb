class UserGroupMembership < ApplicationRecord
  belongs_to :user, inverse_of: :user_group_memberships
  belongs_to :user_group, inverse_of: :user_group_memberships
end
