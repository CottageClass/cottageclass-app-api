class RemoveUserMatches < ActiveRecord::Migration[5.2]
  def change
    drop_table :user_matches
  end
end