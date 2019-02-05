class Notification < ApplicationRecord
  store_accessor :meta, :participant

  enum kind: {
    direct: 0,
    event_reminder_previous_day_participant: 1,
    event_reminder_same_day_participant: 2,
    event_feedback_participant: 3,
    event_reminder_previous_week_host: 4,
    event_reminder_previous_day_host: 5,
    event_feedback_host: 6,
    event_congratulation_host: 7,
    participant_creation: 8,
    user_creation: 9,
    participant_creation_next_day: 10,
    event_destruction: 11,
    participant_creation_host: 12
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
    if recipient.present?
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
                   self.body = I18n.t 'messages.event_feedback_participant',
                                      participant_first_name: recipient.first_name
                   Notifier::EventFeedbackParticipant.new user: recipient, event: notifiable, body: body
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
                   Notifier::EventReminderPreviousDayHost.new user: recipient, event: notifiable, body: body
                 when :event_feedback_host
                   self.body = I18n.t 'messages.event_feedback_host'
                   Notifier::EventFeedbackHost.new user: recipient, event: notifiable, body: body
                 when :event_congratulation_host
                   self.body = I18n.t 'messages.event_congratulation_host', host_first_name: recipient.first_name
                   Notifier::Base.new user: recipient, body: body
                 when :participant_creation
                   self.body = 'placeholder for body'
                   Notifier::ParticipantCreation.new user: recipient, event: notifiable, body: body
                 when :user_creation
                   self.body = 'placeholder for body'
                   Notifier::UserCreation.new user: recipient, body: body
                 when :participant_creation_next_day
                   self.body = 'placeholder for body'
                   Notifier::ParticipantCreationNextDay.new user: recipient, event: notifiable, body: body
                 when :event_destruction
                   self.body = I18n.t 'messages.event_destruction',
                                      participant_first_name: recipient.first_name,
                                      host_first_name: notifiable.host_first_name,
                                      event_start_date: notifiable.start_date,
                                      event_time_range: notifiable.time_range
                   Notifier::Base.new user: recipient, body: body
                 when :participant_creation_host
                   self.body = 'placeholder for body'
                   Notifier::ParticipantCreationHost.new user: recipient,
                                                         event: notifiable,
                                                         participant: participant,
                                                         body: body
                 end

      if notifier.present?
        identifier_hash = notifier.transmit
        self.email_provider_identifier = identifier_hash.dig :email
        self.sms_provider_identifier = identifier_hash.dig :message
      end
    end
  end
end
