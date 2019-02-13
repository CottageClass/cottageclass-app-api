class UserBaseSerializer
  include FastJsonapi::ObjectSerializer

  has_many :children, serializer: ChildSerializer

  set_type :user

  attributes(*User::PUBLIC_ATTRIBUTES)
end
