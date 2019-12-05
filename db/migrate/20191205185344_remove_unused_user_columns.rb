class RemoveUnusedUserColumns < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :instagram_user
    remove_column :users, :twitter_user
    remove_column :users, :linkedin_user
    remove_column :users, :referrer
    remove_column :users, :source_tags
    remove_column :users, :agree_tos
    remove_column :users, :school
  end
end
