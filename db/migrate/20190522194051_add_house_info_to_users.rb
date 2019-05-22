class AddHouseInfoToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :has_pets, :boolean
    add_column :users, :pet_description, :text
    add_column :users, :house_rules, :text
  end
end
