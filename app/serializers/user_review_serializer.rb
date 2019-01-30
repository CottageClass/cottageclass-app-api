class UserReviewSerializer
  include FastJsonapi::ObjectSerializer

  belongs_to :reviewer

  attributes :body, :rating
end
