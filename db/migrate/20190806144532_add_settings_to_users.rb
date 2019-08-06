class AddSettingsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :settings, :jsonb, default: User::DEFAULT_SETTINGS
  end
end
