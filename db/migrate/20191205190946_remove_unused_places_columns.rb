class RemoveUnusedPlacesColumns < ActiveRecord::Migration[5.2]
  def change
    remove_column :places, :street_number
    remove_column :places, :route
    remove_column :places, :sublocality
    remove_column :places, :admin_area_level_2
    remove_column :places, :postal_code
    remove_column :places, :phone_area_code
    remove_column :places, :description
    remove_column :places, :phone_number
  end
end
