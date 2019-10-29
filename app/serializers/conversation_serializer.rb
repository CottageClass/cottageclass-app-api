class ConversationSerializer < BaseSerializer
  belongs_to :last_message, serializer: MessageSerializer

  belongs_to :initiator
  belongs_to :recipient
  attributes :created_at

  belongs_to :partner, serializer: PublicUserSerializer do |conversation, params|
    conversation.recipient_id == params[:current_user].id ? conversation.initiator : conversation.recipient
  end
end
