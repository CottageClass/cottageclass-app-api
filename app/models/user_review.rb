class UserReview < ApplicationRecord
  validates :body, presence: true
  validates :rating, presence: true,
                     numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }

  belongs_to :user, inverse_of: :user_reviews
  belongs_to :reviewer, class_name: 'User', inverse_of: :reviewed_users
  belongs_to :reviewable, polymorphic: true, inverse_of: :user_reviews, optional: true
end
