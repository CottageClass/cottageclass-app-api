class RemoveKeyValue < ActiveRecord::Migration[5.2]
  def change
    drop_table :key_values
  end
end
