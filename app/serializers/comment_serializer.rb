class CommentSerializer < BaseSerializer
  set_type :comment
  belongs_to :sender, serializer: :public_user
  attribute :content
end
