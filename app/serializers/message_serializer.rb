class MessageSerializer < BaseSerializer
  attributes :sender_id,
             :receiver_id,
             :content,
             :created_at
end
