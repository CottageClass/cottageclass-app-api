class CreateEmergencyContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :emergency_contacts do |t|
      t.references :contactable, polymorphic: true, null: false
      t.string :name, :phone_number, :relationship
      t.timestamps null: true
    end
  end
end
