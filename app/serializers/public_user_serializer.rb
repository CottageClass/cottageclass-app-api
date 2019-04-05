class PublicUserSerializer < BaseSerializer
  set_type :user
  has_many :children, serializer: ChildSerializer
  has_many :user_reviews

  attributes(*User::PUBLIC_ATTRIBUTES)
end
