class AddOnboardingAttrsToUsers < ActiveRecord::Migration[5.2]
  def change
    change_table :users, bulk: true do |t|
      t.boolean :agree_tos, default: false
      t.decimal :latitude, :longitude
      t.string :street_number, :route, :locality, :admin_area_level_1, :admin_area_level_2, :postal_code,
               :phone_area_code, :phone_number
      t.string :country, default: 'United States'
      t.string :phone_country_code, default: '1'
      t.index %i[latitude longitude]
    end
  end
end
