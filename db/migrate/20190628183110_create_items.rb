class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :search_list_items do |t|
      t.references :user, foreign_key: true, null: false
      t.references :itemable, polymorphic: true
      t.index %i[user_id itemable_type itemable_id],
              unique: true,
              name: :index_items_on_itemable_type_itemable_id_user_id
    end
  end
end
