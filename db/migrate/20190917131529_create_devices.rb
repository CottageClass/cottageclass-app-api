class CreateDevices < ActiveRecord::Migration[5.2]
  def change
    create_table :devices do |t|
      t.string :token
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
