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
    participant_creation_host: 12,
    user_sms_welcome: 14,
    password_reset_request: 15,
    event_creation_starrer: 18,
    daily_digest: 20,
    chat_message_received: 21,
    new_group_message: 22
  }

  belongs_to :recipient, class_name: 'User', inverse_of: :notifications
  belongs_to :notifiable, polymorphic: true, inverse_of: :notifications, optional: true

  before_create :transmit

  private

  def transmit
    if recipient.present?
      notifier = case kind.to_sym
                 when :direct
                   Notifier::Base.new user: recipient, body: body
                 when :event_reminder_previous_day_participant
                   self.body = I18n.t 'messages.event_reminder_previous_day_participant',
                                      participant_first_name: recipient.first_name,
                                      host_first_name: notifiable.user.first_name,
                                      event_time_range: notifiable.time_range
                   Notifier::Base.new user: recipient, body: body
                 when :event_reminder_same_day_participant
                   self.body = I18n.t 'messages.event_reminder_same_day_participant',
                                      participant_first_name: recipient.first_name,
                                      host_first_name: notifiable.user.first_name,
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
                                      host_first_name: notifiable.user.first_name,
                                      event_time_range: notifiable.time_range
                   Notifier::EventReminderPreviousDayHost.new user: recipient, event: notifiable, body: body
                 when :password_reset_request
                   self.body = I18n.t 'messages.password_reset_request'
                   if recipient.token.present?
                     Notifier::PasswordResetRequest.new user: recipient,
                                                        token: recipient.token,
                                                        body: body
                   end
                 when :event_feedback_host
                   self.body = I18n.t 'messages.event_feedback_host'
                   Notifier::EventFeedbackHost.new user: recipient, event: notifiable, body: body
                 when :participant_creation
                   self.body = 'placeholder for body'
                   Notifier::ParticipantCreation.new user: recipient, event: notifiable, body: body
                 when :user_sms_welcome
                   self.body = I18n.t 'messages.user_sms_welcome'
                   Notifier::UserSmsWelcome.new user: recipient, body: body
                 when :user_creation
                   self.body = 'placeholder for body'
                   Notifier::UserCreation.new user: recipient, body: body
                 when :participant_creation_next_day
                   self.body = 'placeholder for body'
                   Notifier::ParticipantCreationNextDay.new user: recipient, event: notifiable, body: body
                 when :event_destruction
                   self.body = I18n.t 'messages.event_destruction',
                                      participant_first_name: recipient.first_name,
                                      host_first_name: notifiable.user.first_name,
                                      event_start_date: notifiable.start_date,
                                      event_time_range: notifiable.time_range
                   Notifier::Base.new user: recipient, body: body
                 when :participant_creation_host
                   self.body = 'placeholder for body'
                   Notifier::ParticipantCreationHost.new user: recipient,
                                                         event: notifiable,
                                                         participant: participant,
                                                         body: body
                 when :event_creation_starrer
                   self.body = 'messages.event_creation_starrer'
                   Notifier::EventCreationStarrer.new user: recipient,
                                                      notifiable_user: notifiable,
                                                      body: body
                 when :daily_digest
                   self.body = 'messages.daily_digest'
                   Notifier::DailyDigest.new user: recipient,
                                             event_collection: notifiable,
                                             body: body
                 when :chat_message_received
                   ages = notifiable.sender.child_ages_in_months.sort
                   if ages.length == 1
                     sender_kids_ages = '1 kid age ' + display_age(ages[0], 'mo')
                   else
                     display_ages = ages.map { |age| display_age(age, 'mo') }
                     if display_ages.present?
                       and_join_ages = display_ages.slice(0, display_ages.length - 1).join(', ') + ' and ' + display_ages[-1]
                       sender_kids_ages = ages.count.to_s + ' kids ages ' + and_join_ages
                     end
                   end
                   self.body = I18n.t 'messages.chat_message_received',
                                      sender_first_name: notifiable.sender.first_name,
                                      sender_last_initial: notifiable.sender.last_initial,
                                      sender_kids_ages: sender_kids_ages,
                                      message_link: ENV['LINK_HOST'] + '/chat/' + notifiable.sender.id.to_s
                   Notifier::ChatMessageReceived.new user: recipient,
                                                     message: notifiable,
                                                     body: body
                 when :new_group_message
                   group_name = notifiable.group.name
                   ages = notifiable.sender.child_ages_in_months.sort
                   if ages.length == 1
                     sender_kids_ages = '1 kid age ' + display_age(ages[0], 'mo')
                   else
                     display_ages = ages.map { |age| display_age(age, 'mo') }
                     if display_ages.present?
                       and_join_ages = display_ages.slice(0, display_ages.length - 1).join(', ') + ' and ' + display_ages[-1]
                       sender_kids_ages = ages.count.to_s + ' kids ages ' + and_join_ages
                     end
                   end
                   self.body = I18n.t 'messages.new_group_message',
                                      sender_first_name: notifiable.sender.first_name,
                                      sender_last_initial: notifiable.sender.last_initial,
                                      sender_kids_ages: sender_kids_ages,
                                      group_name: group_name,
                                      group_message_link: ENV['LINK_HOST'] + '/group-chat/' + notifiable.group.id.to_s
                   Notifier::NewGroupMessage.new user: recipient,
                                                 comment: notifiable,
                                                 body: body

                 end

      if notifier.present?
        identifier_hash = notifier.transmit
        self.email_provider_identifier = identifier_hash.dig :email
        self.sms_provider_identifier = identifier_hash.dig :message
      end

      # Cannot use normal validations for these, generated after validation
      if body.blank?
        errors.add :body, :required
        raise ActiveRecord::RecordInvalid
      elsif email_provider_identifier.blank? && sms_provider_identifier.blank?
        errors.add :sms_provider_identifier, :required
        raise ActiveRecord::RecordInvalid
      elsif email_provider_identifier.present? &&
            self.class.where(email_provider_identifier: email_provider_identifier).any?
        errors.add :email_provider_identifier, :invalid
        raise ActiveRecord::RecordInvalid
      elsif sms_provider_identifier.present? && self.class.where(sms_provider_identifier: sms_provider_identifier).any?
        errors.add :sms_provider_identifier, :invalid
        raise ActiveRecord::RecordInvalid
      end
    end
  end

  def display_age(age_in_months, month_unit)
    if age_in_months < 24
      age_in_months.to_s + ' ' + month_unit + (age_in_months > 1 ? 's' : '')
    else
      (age_in_months / 12).to_s
    end
  end
end
