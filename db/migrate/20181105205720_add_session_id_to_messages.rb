class AddSessionIdToMessages < ActiveRecord::Migration[5.2]
  def change
    add_reference :messages, :cc_twilio_session, index: true, foreign_key: { to_table: :twilio_sessions }
    add_column :messages, :twilio_interaction_sid, :string
  end
end
