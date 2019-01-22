class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.text :body, null: false
      t.references :recipient, null: false
      t.references :notifiable, polymorphic: true, null: true
      t.integer :kind, default: 0
      t.string :sms_provider_identifier, :email_provider_identifier
      t.string :status
      t.json :meta
      t.timestamps null: true
    end
  end
end
