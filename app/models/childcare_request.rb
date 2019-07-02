class ChildcareRequest < ApplicationRecord
  belongs_to :user, inverse_of: :childcare_requests

  attribute :content
end
