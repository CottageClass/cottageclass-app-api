class RemoveLatLngFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_index :users,
                 name: :index_users_on_fuzzy_latitude_and_fuzzy_longitude,
                 column: %i[fuzzy_latitude fuzzy_longitude]
    remove_index :users,
                 name: :index_users_on_latitude_and_longitude,
                 column: %i[latitude longitude]

    remove_column :users, :latitude, :decimal
    remove_column :users, :longitude, :decimal
    remove_column :users, :fuzzy_latitude, :decimal
    remove_column :users, :fuzzy_longitude, :decimal
    remove_column :users, :street_number, :string
    remove_column :users, :apartment_number, :string
    remove_column :users, :neighborhood, :string
    remove_column :users, :sublocality, :string
    remove_column :users, :time_zone, :string
    remove_column :users, :route, :string
    remove_column :users, :locality, :string
    remove_column :users, :admin_area_level_1, :string
    remove_column :users, :admin_area_level_2, :string
    remove_column :users, :country, :string
  end
end
