class PlaceReview < ApplicationRecord
  belongs_to :place, inverse_of: :place_reviews
  belongs_to :user, inverse_of: :place_reviews
end
