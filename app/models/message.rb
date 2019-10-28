class Message < ApplicationRecord
  belongs_to :sender, class_name: 'User', inverse_of: :sent_messages
  belongs_to :receiver, class_name: 'User', inverse_of: :received_messages

  scope :with_participants, lambda { |p1_id, p2_id|
    where(
      '(sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?)',
      p1_id, p2_id,
      p2_id, p1_id
    )
  }
end
