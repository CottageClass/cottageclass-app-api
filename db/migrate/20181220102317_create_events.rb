class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.references :event_series, null: false
      t.string :name, null: false
      t.string :time_zone
      t.datetime :starts_at, :ends_at, null: false
      t.integer :maximum_children, :child_age_minimum, :child_age_maximum, :kind, default: 0
      t.boolean :modified, :has_pet, default: false
      t.text :activity_names, :foods, array: true, default: []
      t.text :house_rules, :pet_description
      t.json :meta
      t.decimal :latitude, :longitude
      t.timestamps null: true
      t.index %i[latitude longitude]
    end
  end
end
