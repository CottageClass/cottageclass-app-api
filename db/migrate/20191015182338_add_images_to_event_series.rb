class AddImagesToEventSeries < ActiveRecord::Migration[5.2]
  def change
    add_column :event_series, :images, :text, array: true, default: []
  end
end
