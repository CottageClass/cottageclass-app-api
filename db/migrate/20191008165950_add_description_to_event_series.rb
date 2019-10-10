class AddDescriptionToEventSeries < ActiveRecord::Migration[5.2]
  def change
    add_column :event_series, :description, :text
  end
end
