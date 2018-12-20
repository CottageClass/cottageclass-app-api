class CreateEvents < ActiveRecord::Migration[5.2]
  def up
    create_table :events do |t|
      t.references :event_series, null: false
      t.string :name, null: false
      t.datetime :starts_at, :ends_at, null: false
      t.boolean :modified, default: false
      t.json :meta
      t.timestamps null: true
    end
    add_column(:children, :school_name, :string) unless column_exists?(:children, :school_name)
  end

  def down
    remove_column(:children, :school_name, :string) if column_exists?(:children, :school_name)
    drop_table :events
  end
end
