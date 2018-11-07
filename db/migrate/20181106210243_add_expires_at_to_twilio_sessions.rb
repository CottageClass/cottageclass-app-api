class AddExpiresAtToTwilioSessions < ActiveRecord::Migration[5.2]
  def change
    add_column :twilio_sessions, :expires_at, :datetime
  end
end
