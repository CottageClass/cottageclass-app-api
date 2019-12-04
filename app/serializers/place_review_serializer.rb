class PlaceReviewSerializer < BaseSerializer
  set_type :place_review
  belongs_to :user, serializer: :public_user
  belongs_to :place

  attributes :stars, :content, :created_at
end
