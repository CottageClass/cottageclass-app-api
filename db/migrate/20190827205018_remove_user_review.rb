class RemoveUserReview < ActiveRecord::Migration[5.2]
  def change
    drop_table :user_reviews
  end
end
