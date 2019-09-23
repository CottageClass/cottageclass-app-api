class RemoveSettings < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :setting_max_distance, :decimal, default: 2
    add_column :users, :setting_email_notifications, :boolean, default: true

    reversible do |dir|
      dir.up do
        User.find_each do |user|
          if user.settings.present?
            if user.settings['matching'].present?
              dist = user.settings['matching']['max_distance']
              user.update_columns setting_max_distance: dist
            end
            if user.settings['email'].present?
              email = user.settings['email']['receive_weekly_email']
              user.update_columns setting_email_notifications: email
            end
          end
        end
      end
      dir.down do
        User.find_each do |user|
          dist = user.setting_max_distance
          email = user.setting_email_notifications
          user.update_columns settings: { matching: { max_distance: dist }, email: { receive_weekly_email: email } }
        end
      end
    end

    remove_column :users, :settings, :jsonb
  end
end
