class RemoveFoodAndActivityNamesFromEvents < ActiveRecord::Migration[5.2]
  def change
    remove_column :events, :foods
    remove_column :events, :activity_names
    remove_column :events, :pet_description
    remove_column :events, :has_pet
    remove_column :events, :house_rules

    remove_column :event_series, :foods
    remove_column :event_series, :activity_names
    remove_column :event_series, :pet_description
    remove_column :event_series, :has_pet
    remove_column :event_series, :house_rules
  end
end
