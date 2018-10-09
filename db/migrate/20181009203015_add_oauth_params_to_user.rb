class AddOauthParamsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :facebook_uid, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :name, :string
  end
end
