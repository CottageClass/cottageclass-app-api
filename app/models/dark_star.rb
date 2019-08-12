class DarkStar < ApplicationRecord
  belongs_to :giver, class_name: 'User', inverse_of: :dark_stars
  belongs_to :recipient, class_name: 'User', inverse_of: :received_dark_stars
end
