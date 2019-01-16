class AddNotifiableToNotification < ActiveRecord::Migration[5.2]
  def up
    add_column(:notifications, :kind, :integer, default: 0) unless column_exists?(:notifications, :kind)
    unless column_exists?(:notifications, :notifiable_id)
      add_reference :notifications, :notifiable, polymorphic: true, null: true
    end
  end

  def down
    if column_exists?(:notifications, :notifiable_id)
      remove_reference :notifications, :notifiable, polymorphic: true, null: true
    end
    remove_column(:notifications, :kind) if column_exists?(:notifications, :kind)
  end
end
