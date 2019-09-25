class CreatePlaces < ActiveRecord::Migration[5.2]
  def change
    create_table :places do |t|
      t.string :google_id, null: false
      t.float :latitude, null: false
      t.float :longitude, null: false
      t.string :full_address, null: false
      t.boolean :public, null: false
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
    add_index :places, :google_id, unique: true
  end
end
