class AddSenderIdAndReceiverIdToTwilioSessions < ActiveRecord::Migration[5.2]
  def change
    remove_column :twilio_sessions, :participant_ids
    add_reference :twilio_sessions, :sender, index: true, foreign_key: { to_table: :users }
    add_reference :twilio_sessions, :receiver, index: true, foreign_key: { to_table: :users }
  end
end
