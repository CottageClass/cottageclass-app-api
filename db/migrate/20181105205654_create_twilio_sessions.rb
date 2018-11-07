class CreateTwilioSessions < ActiveRecord::Migration[5.2]
  def change
    create_table :twilio_sessions do |t|
      t.string :friendly_name
      t.string :twilio_id
    end
  end
end
