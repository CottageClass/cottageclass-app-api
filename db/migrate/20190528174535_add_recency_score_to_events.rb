class AddRecencyScoreToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :recency_score, :float
  end
end
