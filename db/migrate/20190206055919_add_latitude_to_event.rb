class AddLatitudeToEvent < ActiveRecord::Migration[5.2]
  def up
    unless column_exists?(:events, :latitude)
      add_column :events, :latitude, :decimal
      add_column :events, :longitude, :decimal
      add_index :events, %i[latitude longitude]
    end
  end

  def down
    if column_exists?(:events, :latitude)
      remove_index :events, %i[latitude longitude]
      remove_column :events, :longitude, :decimal
      remove_column :events, :latitude, :decimal
    end
  end
end
