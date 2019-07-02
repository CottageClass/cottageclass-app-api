class AddUniquePartialIndexToSearchListItems < ActiveRecord::Migration[5.2]
  # adds an index to the search list item table that guarantees uniqueness
  # among users with no itemables
  def change
    add_index :search_list_items,
              %i[user_id],
              unique: true,
              name: 'index_items_on_user_with_null_itemable',
              where: 'itemable_id IS NULL'
  end
end
