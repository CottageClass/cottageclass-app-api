class AddEmergencyContactNameToChild < ActiveRecord::Migration[5.2]
  def up
    string_columns.each { |column| add_column(:children, column, :string) unless column_exists?(:children, column) }
    array_columns.each do |column|
      add_column(:children, column, :text, array: true, default: []) unless column_exists?(:children, column)
    end
    add_column(:children, :special_needs, :text) unless column_exists?(:children, :special_needs)
  end

  def down
    remove_column(:children, :special_needs) if column_exists?(:children, :special_needs)
    array_columns.each { |column| remove_column(:children, column) if column_exists?(:children, column) }
    string_columns.each { |column| remove_column(:children, column) if column_exists?(:children, column) }
  end

  def string_columns
    %i[emergency_contact_name emergency_contact_phone_number emergency_contact_relationship]
  end

  def array_columns
    %i[allergies dietary_restrictions]
  end
end
