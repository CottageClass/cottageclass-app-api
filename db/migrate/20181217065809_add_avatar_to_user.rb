class AddAvatarToUser < ActiveRecord::Migration[5.2]
  def up
    add_column(:users, :avatar, :string) unless column_exists?(:users, :avatar)
  end

  def down
    remove_column(:users, :avatar) if column_exists?(:users, :avatar)
  end
end
