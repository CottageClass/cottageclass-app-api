class CreateChildren < ActiveRecord::Migration[5.2]
  def change
    create_table :children do |t|
      t.string :first_name, :school_name
      t.datetime :birthday
      t.references :user, foreign_key: true
      t.text :allergies, :dietary_restrictions, default: [], array: true
      t.text :special_needs
      t.timestamps
    end
  end
end
