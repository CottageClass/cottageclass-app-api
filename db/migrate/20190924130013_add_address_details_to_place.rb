class AddAddressDetailsToPlace < ActiveRecord::Migration[5.2]
  def change
    change_table :places, bulk: true do |t|
      t.decimal :fuzzy_latitude, :fuzzy_longitude
      t.string :street_number, :route, :locality, :sublocality, :neighborhood, :admin_area_level_1,
               :admin_area_level_2, :postal_code, :phone_area_code, :phone_number, :apartment_number
      t.string :country, default: 'United States'
      t.string :phone_country_code, default: '1'
      t.index %i[latitude longitude]
    end
  end
end
