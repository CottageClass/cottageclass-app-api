class RemoveShowcaseEvents < ActiveRecord::Migration[5.2]
  def change
    remove_reference :users, :showcase_event, foreign_key: { to_table: :events }
  end
end
