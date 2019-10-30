class Message < ApplicationRecord
  after_create :update_conversation, :sms_notification

  has_many :notifications, as: :notifiable, dependent: :nullify
  belongs_to :sender, class_name: 'User', inverse_of: :sent_messages
  belongs_to :receiver, class_name: 'User', inverse_of: :received_messages

  scope :with_participants, lambda { |p1_id, p2_id|
    where(
      '(sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?)',
      p1_id, p2_id,
      p2_id, p1_id
    )
  }
  scope :with_participant, lambda { |id|
    where(
      '(sender_id = ?) OR (receiver_id = ?)',
      id, id
    )
  }

  def sms_notification
    receiver.notifications.chat_message_received.create notifiable: self
  end

  private

  def update_conversation
    convo = Conversation.with_participants(receiver, sender).first_or_create
    convo.update initiator: sender, recipient: receiver if convo.new_record?
    convo.last_message = self
    convo.save!
  end
end
