class Notification < ApplicationRecord
  validates :body, presence: true
  validates :remote_identifier, presence: true, uniqueness: { case_sensitive: false }

  belongs_to :recipient, class_name: 'User', inverse_of: :notifications

  before_validation :transmit

  def transmit
    if body.present? && recipient.present?
      twilio_client = Twilio::REST::Client.new ENV.fetch('TWILIO_ACCOUNT_SID'), ENV.fetch('TWILIO_AUTH_TOKEN')

      message = twilio_client.api.account.messages.create from: ENV.fetch('TWILIO_SENDER_NUMBER'),
                                                          to: recipient.phone,
                                                          body: body
      self.remote_identifier = message.sid
    end
  end
end
