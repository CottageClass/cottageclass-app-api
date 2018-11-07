class AddTwilioParticipantSidsToTwilioSessions < ActiveRecord::Migration[5.2]
  def change
    add_column :twilio_sessions, :twilio_sid_sender, :string
    add_column :twilio_sessions, :twilio_sid_receiver, :string
  end
end
