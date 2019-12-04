class UserGroupMembershipIndex < ActiveRecord::Migration[5.2]
  def change
    add_index :user_group_memberships, %i[user_id user_group_id], unique: true
  end
end
