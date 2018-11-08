class TwilioSession < ApplicationRecord
  # Twilio sessions last 1 day from last action
  TTL_SECONDS = 60 * 60 * 24

  alias_attribute :unique_name, :friendly_name
  alias_attribute :twilio_sid, :twilio_id

  before_validation :ensure_last_action_utc

  validates :participant_ids, length: {
    maximum: 2,
    message: 'A session can have up to two participants max',
  }

  scope :live, -> {
    where(
      'last_action_at > ?',
      # remember to normalize all times to UTC for comparison
      live_session_cutoff,
    )
  }
  scope :with_participants, -> (*participant_ids) {
    where(
      'participant_ids @> ?',
      "{#{participant_ids.join(',')}}",
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
