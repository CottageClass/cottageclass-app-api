class MessageSerializer < BaseSerializer
  attributes :sender_id,
             :receiver_id,
             :content,
             :cc_twilio_session_id,
             :twilio_interaction_sid,
             :created_at
end
