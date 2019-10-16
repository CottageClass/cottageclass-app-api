class AddLatLngsToTables < ActiveRecord::Migration[5.2]
  TABLES_TO__ADD_LAT_LNGS = %i[users events event_series].freeze

  def change
    TABLES_TO__ADD_LAT_LNGS.each do |table|
      change_table table, bulk: true do |t|
        t.decimal :latitude, :longitude
      end
    end
  end
end
