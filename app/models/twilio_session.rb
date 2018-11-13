class TwilioSession < ApplicationRecord
  # Twilio sessions last 7 days from last action
  TTL_SECONDS = 60 * 60 * 24 * 7

  alias_attribute :unique_name, :friendly_name
  alias_attribute :twilio_sid, :twilio_id
  # rename sender->initiator, receiver->client
  alias_attribute :initiator_id, :sender_id
  alias_attribute :client_id, :receiver_id
  alias_attribute :twilio_sid_initiator, :twilio_sid_sender
  alias_attribute :twilio_sid_client, :twilio_sid_receiver
  alias_attribute :proxy_identifier_initiator, :proxy_identifier_sender
  alias_attribute :proxy_identifier_client, :proxy_identifier_receiver

  belongs_to :initiator, class_name: 'User', foreign_key: :sender_id
  belongs_to :client, class_name: 'User', foreign_key: :receiver_id
  has_many :messages, class_name: 'Message', foreign_key: :cc_twilio_session_id

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
      '(sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?)',
      p1_id, p2_id,
      p2_id, p1_id,
    )
  }

  def self.live_session_cutoff
    TTL_SECONDS.seconds.ago.utc
  end

  def record_action!(time=DateTime.now.utc)
    update_attributes(last_action_at: time)
  end


  private

  def ensure_last_action_utc
    self.last_action_at = self.last_action_at.utc
  end
end
