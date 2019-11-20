class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.references :sender
      t.references :group
      t.text :conent

      t.timestamps
    end
  end
end
