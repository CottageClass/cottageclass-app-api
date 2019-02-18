class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email, :avatar, :referrer
      t.decimal :fuzzy_latitude, :fuzzy_longitude
      t.string :password_digest, :apartment_number, :neighborhood, :sublocality, :time_zone
      t.text :source_tags, array: true, default: []
      t.boolean :verified, default: false
      t.index %i[fuzzy_latitude fuzzy_longitude]
      t.timestamps
    end
  end
end
