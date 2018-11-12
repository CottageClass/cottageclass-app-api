class Message < ApplicationRecord
  belongs_to :sender, class_name: 'User', inverse_of: :sent_messages
  belongs_to :receiver, class_name: 'User', inverse_of: :received_messages
  belongs_to :cc_twilio_session, class_name: 'TwilioSession'

  scope :with_participants, -> (p1_id, p2_id) {
    where(
      '(sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?)',
      p1_id, p2_id,
      p2_id, p1_id,
    )
  }

end
