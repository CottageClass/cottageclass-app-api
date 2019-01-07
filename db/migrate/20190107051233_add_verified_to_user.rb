class AddVerifiedToUser < ActiveRecord::Migration[5.2]
  def up
    add_column(:users, :verified, :boolean, default: false) unless column_exists?(:users, :verified)
  end

  def down
    remove_column(:users, :verified) if column_exists?(:users, :verified)
  end
end
