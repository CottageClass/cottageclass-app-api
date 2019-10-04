class AddMorePlaceDetails < ActiveRecord::Migration[5.2]
  def change
    change_table :places, bulk: true do |t|
      t.jsonb :full_result_object
      t.string :vicinity
    end
  end
end
