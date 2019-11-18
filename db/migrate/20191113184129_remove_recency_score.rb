class RemoveRecencyScore < ActiveRecord::Migration[5.2]
  def change
    remove_column :events, :recency_score, :float
  end
end
