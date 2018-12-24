class AddHouseRulesToEvent < ActiveRecord::Migration[5.2]
  def up
    %i[event_series events].each do |table|
      integer_columns.each { |column| add_column(table, column, :integer, default: 0) unless column_exists?(table, column) }
    end
    add_column(:events, :maximum_children, :boolean, default: false) unless column_exists?(:events, :maximum_children)
    add_column(:events, :has_pet, :boolean, default: false) unless column_exists?(:events, :has_pet)
    array_columns.each do |column|
      add_column(:events, column, :text, array: true, default: []) unless column_exists?(:events, column)
    end
    text_columns.each { |column| add_column(:events, column, :text) unless column_exists?(:events, column) }

    unless table_exists?(ActiveRecord::ModelSchema.derive_join_table_name(:event_hosts, :events))
      create_join_table(:event_hosts, :events) { |t| t.index(%i[event_host_id event_id], unique: true) }
    end
  end

  def down
    if table_exists?(ActiveRecord::ModelSchema.derive_join_table_name(:event_hosts, :events))
      drop_join_table :event_hosts, :events
    end

    text_columns.each { |column| remove_column(:events, column) if column_exists?(:events, column) }
    array_columns.each { |column| remove_column(:events, column) if column_exists?(:events, column) }
    remove_column(:events, :has_pet) if column_exists?(:events, :has_pet)
    %i[event_series events].each do |table|
      integer_columns.each { |column| remove_column(table, column) if column_exists?(table, column) }
    end
  end

  def array_columns
    %i[activity_names foods]
  end

  def text_columns
    %i[house_rules pet_description]
  end

  def integer_columns
    %i[maximum_children child_age_minimum child_age_maximum]
  end
end
