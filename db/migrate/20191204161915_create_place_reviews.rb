class CreatePlaceReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :place_reviews do |t|
      t.references :place, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :stars
      t.text :content

      t.timestamps
    end
  end
end
