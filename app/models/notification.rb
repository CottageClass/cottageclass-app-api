class Notification < ApplicationRecord
  enum kind: {
    direct: 0,
    event_reminder_previous_day_participant: 1,
    event_reminder_same_day_participant: 2,
    event_feedback_participant: 3,
    event_reminder_previous_week_host: 4,
    event_reminder_previous_day_host: 5,
    event_feedback_host: 6,
    event_congratulation_host: 7
  }

  validates :body, presence: true
  validates :remote_identifier, presence: true, uniqueness: { case_sensitive: false }
  validate do |instance|
    # For live testing
    restrict_notifications_to = ENV.fetch('RESTRICT_NOTIFICATIONS_TO', '').split(',').map(&:squish).map(&:to_i)
    if restrict_notifications_to.present? && restrict_notifications_to.exclude?(instance.recipient.try(:id))
      instance.errors.add :recipient, :invalid, message: 'is excluded by configuration'
    end
  end

  belongs_to :recipient, class_name: 'User', inverse_of: :notifications
  belongs_to :notifiable, polymorphic: true, inverse_of: :notifications, optional: true

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
