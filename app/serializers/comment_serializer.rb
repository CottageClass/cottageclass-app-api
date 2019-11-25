class CommentSerializer < BaseSerializer
  set_type :comment
  belongs_to :sender, serializer: :public_user
  attributes :content, :created_at
end
