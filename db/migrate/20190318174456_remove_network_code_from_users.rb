class RemoveNetworkCodeFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :network_code, :string
  end
end
