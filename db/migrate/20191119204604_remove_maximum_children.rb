class RemoveMaximumChildren < ActiveRecord::Migration[5.2]
  def change
    remove_column :events, :maximum_children, :integer
    remove_column :event_series, :maximum_children, :integer
  end
end
