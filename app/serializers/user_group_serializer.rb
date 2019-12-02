class UserGroupSerializer < BaseSerializer
  has_many :members, serializer: :public_user
end
