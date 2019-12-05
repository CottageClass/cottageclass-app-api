class RemoveUnusedChildrenColumns < ActiveRecord::Migration[5.2]
  def change
    remove_column :children, :allergies
    remove_column :children, :dietary_restrictions
    remove_column :children, :special_needs
  end
end
