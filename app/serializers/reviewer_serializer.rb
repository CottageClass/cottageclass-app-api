class ReviewerSerializer
  include FastJsonapi::ObjectSerializer

  set_type :user

  attributes :first_name, :last_name, :verified, :avatar, :facebook_id
end
