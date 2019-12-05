class PlaceReview < ApplicationRecord
  belongs_to :place, inverse_of: :place_reviews
  belongs_to :user, inverse_of: :place_reviews

  validates :stars,
            presence: true,
            numericality: { only_integer: true,
                            greater_than_or_equal_to: 1,
                            less_than_or_equal_to: 5 }
  validates :content, presence: true
end
