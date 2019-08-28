class RemovePausedColumnsFromEventSeries < ActiveRecord::Migration[5.2]
  def change
    remove_column :event_series, :paused_from
    remove_column :event_series, :paused_until
  end
end
