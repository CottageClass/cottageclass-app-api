class CreateChildcareRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :childcare_requests do |t|
      t.references :user, foreign_key: true
      t.text :content
    end
  end
end
