class Message < ApplicationRecord
  belongs_to :sender, class_name: 'User', foreign_key: :sender_id, inverse_of: :sent_messages
  belongs_to :receiver, class_name: 'User', foreign_key: :receiver_id, inverse_of: :received_messages
  belongs_to :cc_twilio_session, class_name: 'TwilioSession', foreign_key: :cc_twilio_session_id
end
