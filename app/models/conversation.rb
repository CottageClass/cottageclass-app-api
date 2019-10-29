class Conversation < ApplicationRecord
  belongs_to :initiator, class_name: 'User', dependent: :destroy
  belongs_to :recipient, class_name: 'User', dependent: :destroy
  belongs_to :last_message, class_name: 'Message', dependent: :destroy

  validates :recipient, presence: true
  validates :last_message, presence: true

  scope :with_participants, lambda { |p1_id, p2_id|
    where(
      '(initiator_id = ? AND recipient_id = ?) OR (initiator_id = ? AND recipient_id = ?)',
      p1_id, p2_id,
      p2_id, p1_id
    )
  }
  scope :with_participant, lambda { |id|
    where(
      '(initiator_id = ? OR recipient_id = ?)',
      id, id
    )
  }
end
