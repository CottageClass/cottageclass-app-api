class AddTimestampsToMessagesAndTwilioSessions < ActiveRecord::Migration[5.2]
  def up
    # add new column but allow null values
    add_timestamps :messages, null: true
    add_timestamps :twilio_sessions, null: true

    # backfill existing record with created_at and updated_at
    # values making clear that the records are faked
    long_ago = DateTime.new(1999, 1, 1)
    # Message.update_all(created_at: long_ago, updated_at: long_ago)
    # TwilioSession.update_all(created_at: long_ago, updated_at: long_ago)

    # change not null constraints
    change_column_null :messages, :created_at, false
    change_column_null :messages, :updated_at, false
    change_column_null :twilio_sessions, :created_at, false
    change_column_null :twilio_sessions, :updated_at, false
  end

  def down
    remove_column :messages, :created_at
    remove_column :messages, :updated_at
    remove_column :twilio_sessions, :created_at
    remove_column :twilio_sessions, :updated_at
  end
end
