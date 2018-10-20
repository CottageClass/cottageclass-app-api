class RenameUserIdToParentIdForChild < ActiveRecord::Migration[5.2]
  def self.up
    rename_column :children, :user_id, :parent_id
  end

  def self.down
    rename_column :children, :parent_id, :user_id
  end
end
