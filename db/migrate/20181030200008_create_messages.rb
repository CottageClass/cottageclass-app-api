class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.references :sender, foreign_key: true, index: true, foreign_key: { to_table: :users }
      t.references :receiver, foreign_key: true, index: true, foreign_key: { to_table: :users }
      t.text :content
    end
  end
end
