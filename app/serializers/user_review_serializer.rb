class UserReviewSerializer
  include FastJsonapi::ObjectSerializer

  belongs_to :reviewer, record_type: :user

  attributes :body, :rating
end
