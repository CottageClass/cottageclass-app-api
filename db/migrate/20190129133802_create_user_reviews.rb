class CreateUserReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :user_reviews do |t|
      t.references :user, :reviewer, null: false, index: false
      t.references :reviewable, polymorphic: true, null: true
      t.text :body
      t.integer :rating
      t.timestamps null: true
      t.index %i[user_id reviewer_id], unique: true
    end

    change_table :users, bulk: true do |t|
      t.text :images, array: true, default: []
      t.text :languages, array: true, default: []
      t.string :job_position, :employer, :highest_education, :school, :instagram_user, :twitter_user, :linkedin_user
    end
  end
end
