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
  validates :sms_provider_identifier, presence: { if: proc { |instance| instance.email_provider_identifier.blank? } },
                                      uniqueness: { case_sensitive: false, allow_blank: true }
  validates :email_provider_identifier, presence: { if: proc { |instance| instance.sms_provider_identifier.blank? } },
                                        uniqueness: { case_sensitive: false, allow_blank: true }

  belongs_to :recipient, class_name: 'User', inverse_of: :notifications
  belongs_to :notifiable, polymorphic: true, inverse_of: :notifications, optional: true

  before_validation :transmit

  def transmit
    notifier = case kind.to_sym
               when :direct
                 Notifier::Base.new user: recipient, body: body
               when :event_reminder_previous_day_participant
                 self.body = I18n.t 'messages.event_reminder_previous_day_participant',
                                    participant_first_name: recipient.first_name,
                                    host_first_name: notifiable.host_first_name,
                                    event_time_range: notifiable.time_range
                 Notifier::Base.new user: recipient, body: body
               when :event_reminder_same_day_participant
                 self.body = I18n.t 'messages.event_reminder_same_day_participant',
                                    participant_first_name: recipient.first_name,
                                    host_first_name: notifiable.host_first_name,
                                    event_time_range: notifiable.time_range
                 Notifier::Base.new user: recipient, body: body
               when :event_feedback_participant
                 self.body = I18n.t 'messages.event_feedback_participant', participant_first_name: recipient.first_name
                 Notifier::EventFeedbackParticipant.new user: recipient, body: body
               when :event_reminder_previous_week_host
                 self.body = I18n.t 'messages.event_reminder_previous_week_host',
                                    host_first_name: recipient.first_name,
                                    event_start_date: notifiable.start_date,
                                    event_time_range: notifiable.time_range
                 Notifier::Base.new user: recipient, body: body
               when :event_reminder_previous_day_host
                 self.body = I18n.t 'messages.event_reminder_previous_day_host',
                                    host_first_name: notifiable.host_first_name,
                                    event_time_range: notifiable.time_range
                 Notifier::Base.new user: recipient, body: body
               when :event_feedback_host
                 self.body = I18n.t 'messages.event_feedback_host'
                 Notifier::EventFeedbackHost.new user: recipient, body: body
               when :event_congratulation_host
                 self.body = I18n.t 'messages.event_congratulation_host', host_first_name: recipient.first_name
                 Notifier::Base.new user: recipient, body: body
               end

    if notifier.present?
      identifier_hash = notifier.transmit
      self.email_provider_identifier = identifier_hash.dig :email
      self.sms_provider_identifier = identifier_hash.dig :message
    end
  end
end
