class CreateUserMatches < ActiveRecord::Migration[5.2]
  def change
    create_table :user_matches do |t|
      t.references :user, foreign_key: true
      t.references :matched_user, foreign_key: { to_table: :users }
      t.float :score

      t.index %i[user_id matched_user_id],
              unique: true,
              name: :index_user_matches_on_user_id_matched_user_id
      t.timestamps
    end
  end
end
