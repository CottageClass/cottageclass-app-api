class RemoveKindFromEvent < ActiveRecord::Migration[5.2]
  def change
    remove_column :events, :kind
  end
end
