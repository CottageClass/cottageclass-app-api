class RemoveSearchListItems < ActiveRecord::Migration[5.2]
  def change
    drop_table :search_list_items
  end
end
