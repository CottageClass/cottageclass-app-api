class AddEmailProviderIdentifierToNotification < ActiveRecord::Migration[5.2]
  def up
    add_column(:notifications, :email_provider_identifier, :string) unless column_exists?(:notifications, :email_provider_identifier)
    rename_column(:notifications, :remote_identifier, :sms_provider_identifier) unless column_exists?(:notifications, :sms_provider_identifier)
    change_column_null :notifications, :sms_provider_identifier, true
  end

  def down
    rename_column(:notifications, :sms_provider_identifier, :remote_identifier) unless column_exists?(:notifications, :remote_identifier)
    remove_column(:notifications, :email_provider_identifier) if column_exists?(:notifications, :email_provider_identifier)
  end
end
