class AddRecipientProxyIdentifierToTwilioSessions < ActiveRecord::Migration[5.2]
  def change
    add_column :twilio_sessions, :proxy_identifier_sender, :string
    add_column :twilio_sessions, :proxy_identifier_receiver, :string
  end
end
