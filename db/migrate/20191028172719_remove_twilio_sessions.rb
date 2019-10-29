class RemoveTwilioSessions < ActiveRecord::Migration[5.2]
  def change
    remove_column :messages, :cc_twilio_session_id, :bigint
    remove_column :messages, :twilio_interaction_sid, :string

    drop_table :twilio_sessions
  end
end
