class RemoveEmergencyContacts < ActiveRecord::Migration[5.2]
  def change
    drop_table :emergency_contacts
  end
end
