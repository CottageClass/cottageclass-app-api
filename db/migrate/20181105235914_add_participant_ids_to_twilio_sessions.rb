class AddParticipantIdsToTwilioSessions < ActiveRecord::Migration[5.2]
  def change
    add_column :twilio_sessions, :participant_ids, :string, array: true
  end
end
