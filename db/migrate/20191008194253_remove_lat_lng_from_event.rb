class RemoveLatLngFromEvent < ActiveRecord::Migration[5.2]
  def change
    remove_index :events,
                 name: :index_events_on_latitude_and_longitude,
                 column: %i[latitude longitude]

    remove_column :events, :time_zone, :string
    remove_column :events, :latitude, :decimal
    remove_column :events, :longitude, :decimal
  end
end
