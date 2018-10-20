class IndexUsersOnNetworkCode < ActiveRecord::Migration[5.2]
  def change
    add_index :users, :network_code
  end
end
