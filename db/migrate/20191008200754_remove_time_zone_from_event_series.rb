class RemoveTimeZoneFromEventSeries < ActiveRecord::Migration[5.2]
  def change
    remove_column :event_series, :time_zone, :string
  end
end
