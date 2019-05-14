class Star < ApplicationRecord
  belongs_to :starable, polymorphic: true, inverse_of: :received_stars
  belongs_to :giver, class_name: :User, inverse_of: :stars
end
