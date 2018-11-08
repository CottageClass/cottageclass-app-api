class AddLastActionAtToTwilioSessions < ActiveRecord::Migration[5.2]
  def change
    add_column :twilio_sessions, :last_action_at, :datetime, default: -> { 'CURRENT_TIMESTAMP' }
    remove_column :twilio_sessions, :expires_at
  end
end
