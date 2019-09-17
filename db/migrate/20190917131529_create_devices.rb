class CreateDevices < ActiveRecord::Migration[5.2]
  def self.up
    create_table :devices do |t|
      t.string :token
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
    add_index :devices, :token
  end

  def self.down
    drop_table :devices
  end
end
