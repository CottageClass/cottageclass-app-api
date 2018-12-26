class AddOnboardingAttrsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :agree_tos, :boolean, default: false
    add_column :users, :street_number, :string
    add_column :users, :route, :string
    add_column :users, :locality, :string
    add_column :users, :admin_area_level_1, :string
    add_column :users, :admin_area_level_2, :string
    add_column :users, :country, :string, default: 'United States'
    add_column :users, :postal_code, :string
    add_column :users, :latitude, :string
    add_column :users, :longitude, :string
    add_column :users, :phone_area_code, :string
    add_column :users, :phone_country_code, :string, default: '1'
    add_column :users, :phone_number, :string
  end
end
