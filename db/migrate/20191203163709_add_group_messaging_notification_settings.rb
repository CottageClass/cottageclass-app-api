class AddGroupMessagingNotificationSettings < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :setting_notify_group_messages_push, :boolean, default: true
    add_column :users, :setting_notify_group_messages_email, :boolean, default: true
    add_column :users, :setting_notify_group_messages_sms, :boolean, default: true
  end
end
