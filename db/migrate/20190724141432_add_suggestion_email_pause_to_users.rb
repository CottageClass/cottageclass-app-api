class AddSuggestionEmailPauseToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :pause_suggestion_email, :boolean, null: false, default: false
  end
end
