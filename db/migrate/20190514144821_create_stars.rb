class CreateStars < ActiveRecord::Migration[5.2]
  def change
    create_table :stars do |t|
      t.references :starable, polymorphic: true
      t.references :giver, foreign_key: {to_table: :users}

      t.timestamps
    end
  end
end
