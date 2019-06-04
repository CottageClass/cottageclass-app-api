class CreateStars < ActiveRecord::Migration[5.2]
  def change
    create_table :stars do |t|
      t.references :starable, polymorphic: true
      t.references :giver, foreign_key: {to_table: :users}
      t.index %i[giver_id starable_type starable_id],
              unique: true,
              name: :index_stars_on_starable_type_starable_id_giver_id
      t.timestamps
    end
  end
end
