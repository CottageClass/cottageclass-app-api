class AddPlacesToUsers < ActiveRecord::Migration[5.2]
  def change
    change_table :users, bulk: true do |t|
      t.belongs_to :place, foreign_key: true
    end
  end
end
