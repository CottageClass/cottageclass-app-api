class Star < ApplicationRecord
  belongs_to :starable, polymorphic: true
  belongs_to :giver
end
