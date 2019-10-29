class CreateConversations < ActiveRecord::Migration[5.2]
  def change
    create_table :conversations do |t|
      t.belongs_to :initiator,
                   foreign_key: { to_table: :users }
      t.belongs_to :recipient,
                   foreign_key: { to_table: :users }
      t.index %i[initiator_id recipient_id],
              unique: true
      t.belongs_to :last_message,
                   foreign_key: { to_table: :messages }

      t.timestamps
    end
  end
end
