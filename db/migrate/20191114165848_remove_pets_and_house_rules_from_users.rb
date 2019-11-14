class RemovePetsAndHouseRulesFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :pet_description, :text
    remove_column :users, :has_pet, :boolean
    remove_column :users, :house_rules, :text
  end
end
