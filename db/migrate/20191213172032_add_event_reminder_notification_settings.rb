class AddEventReminderNotificationSettings < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :setting_notify_event_reminder_push, :boolean, default: true
    add_column :users, :setting_notify_event_reminder_email, :boolean, default: true
    add_column :users, :setting_notify_event_reminder_sms, :boolean, default: true
  end
end
