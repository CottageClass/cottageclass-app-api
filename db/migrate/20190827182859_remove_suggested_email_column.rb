class RemoveSuggestedEmailColumn < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :pause_suggestion_email
  end
end
