class CreateEventSeries < ActiveRecord::Migration[5.2]
  def change
    create_table :event_series do |t|
      t.belongs_to :user, null: false
      t.string :name, null: false
      t.string :time_zone
      t.date :start_date, null: false
      t.time :starts_at, :ends_at, null: false
      t.integer :repeat_for, :interval, null: false
      t.integer :maximum_children, :child_age_minimum, :child_age_maximum, default: 0
      t.boolean :has_pet, default: false
      t.text :activity_names, :foods, array: true, default: []
      t.text :house_rules, :pet_description
      t.json :meta
      t.timestamps null: true
    end
  end
end
