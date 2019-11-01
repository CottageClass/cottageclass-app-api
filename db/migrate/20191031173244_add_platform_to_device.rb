class AddPlatformToDevice < ActiveRecord::Migration[5.2]
  def change
    add_column :devices, :platform, :integer, null: false, default: 0
  end
end
