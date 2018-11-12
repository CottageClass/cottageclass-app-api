class TwilioSession < ApplicationRecord
  # Twilio sessions last 1 day from last action
  TTL_SECONDS = 60 * 60 * 24

  alias_attribute :unique_name, :friendly_name
  alias_attribute :twilio_sid, :twilio_id

  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  has_many :messages

  before_validation :ensure_last_action_utc

  scope :live, -> {
    where(
      'last_action_at > ?',
      # remember to normalize all times to UTC for comparison
      live_session_cutoff,
    )
  }
  scope :with_participants, -> (p1_id, p2_id) {
    where(
      '(sender_id = ? AND receiver_id = ?) OR (receiver_id = ? AND sender_id = ?)',
      p1_id, p2_id,
      p1_id, p2_id,
    )
  }

  def self.live_session_cutoff
    TTL_SECONDS.seconds.ago.utc
  end


  private

  def ensure_last_action_utc
    self.last_action_at = self.last_action_at.utc
  end
end
