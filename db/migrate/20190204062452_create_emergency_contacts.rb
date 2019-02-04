class CreateEmergencyContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :emergency_contacts do |t|
      t.references :contactable, polymorphic: true, null: false
      t.string :name, :phone_number, :relationship
      t.text :allergies, :dietary_restrictions, default: [], array: true
      t.text :special_needs
      t.timestamps null: true
    end

    reversible do |direction|
      direction.up do
        %i[
          emergency_contact_name
          emergency_contact_phone_number
          emergency_contact_relationship
          allergies
          dietary_restrictions
          special_needs
        ].each do |column|
          remove_column(:children, column) if column_exists?(:children, column)
        end
      end
    end
  end
end
