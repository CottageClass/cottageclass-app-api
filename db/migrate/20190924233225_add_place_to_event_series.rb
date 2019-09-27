class AddPlaceToEventSeries < ActiveRecord::Migration[5.2]
  def change
    change_table :event_series, bulk: true do |t|
      t.belongs_to :place, foreign_key: true
    end
    remove_column :events, :place_id
  end
end
