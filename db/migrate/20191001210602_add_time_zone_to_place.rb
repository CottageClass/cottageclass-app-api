class AddTimeZoneToPlace < ActiveRecord::Migration[5.2]
  def change
    change_table :places, bulk: true do |t|
      t.string :time_zone
    end
  end
end
