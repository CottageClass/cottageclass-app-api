class AddAllergiesToChild < ActiveRecord::Migration[5.2]
  def up
    %i[allergies dietary_restrictions special_needs].each do |column|
      remove_column(:emergency_contacts, column) if column_exists?(:emergency_contacts, column)
    end
    %i[allergies dietary_restrictions].each do |column|
      add_column(:children, column, :text, default: [], array: true) unless column_exists?(:children, column)
    end
    add_column(:children, :special_needs, :text) unless column_exists?(:children, :special_needs)
  end

  def down
    %i[allergies dietary_restrictions special_needs].each do |column|
      remove_column(:children, column) if column_exists?(:children, column)
    end
    %i[allergies dietary_restrictions].each do |column|
      unless column_exists?(:emergency_contacts, column)
        add_column :emergency_contacts, column, :text, default: [], array: true
      end
    end
    add_column(:emergency_contacts, :special_needs, :text) unless column_exists?(:emergency_contacts, :special_needs)
  end
end
