class AddInternallyClearedToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :internally_cleared, :boolean, null: false, default: false
  end
end
