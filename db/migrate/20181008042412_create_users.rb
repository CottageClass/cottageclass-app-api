class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email, :avatar
      t.decimal :fuzzy_latitude, :fuzzy_longitude
      t.string :password_digest, :time_zone
      t.boolean :verified, default: false
      t.index %i[fuzzy_latitude fuzzy_longitude]
      t.timestamps
    end
  end
end
