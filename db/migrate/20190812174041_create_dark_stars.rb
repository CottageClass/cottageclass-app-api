class CreateDarkStars < ActiveRecord::Migration[5.2]
  def change
    create_table :dark_stars do |t|
      t.references :giver, foreign_key: { to_table: :users }
      t.references :recipient, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end
