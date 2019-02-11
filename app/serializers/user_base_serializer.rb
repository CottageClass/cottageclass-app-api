class UserBaseSerializer
  include FastJsonapi::ObjectSerializer

  set_type :user

  attributes(*User::PUBLIC_ATTRIBUTES)
end
