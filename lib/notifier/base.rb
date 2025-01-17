class Notifier::Base
  def initialize(user:, body:)
    @user = user
    @body = body

    @twilio_client = Twilio::REST::Client.new ENV.fetch('TWILIO_ACCOUNT_SID'), ENV.fetch('TWILIO_AUTH_TOKEN')
    @sendgrid_client = SendgridClient.new

    @sender_phone = ENV.fetch 'TWILIO_SENDER_NUMBER'
    @sender_email = OpenStruct.new email: Rails.configuration.x.reply_to_email, name: 'JoinLilypad.com'

    @user_phone = user.try :phone
  end

  def transmit
    begin
      this_message = message
    rescue => e
      Rails.logger.error 'Failed to send message.'
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.first(5).join("\n")
      {}
    end
    begin
      this_email = email
    rescue => e
      Rails.logger.error 'Failed to send email.'
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.first(5).join("\n")
      {}
    end
    {
      message: this_message,
      email: this_email
    }
  end

  def message
    output = nil
    if @sender_phone.present? && @user_phone.present? && @body.present?
      message = @twilio_client.api.account.messages.create from: @sender_phone, to: @user_phone, body: @body
      output = message.sid
    end
    output
  end

  def email
    Rails.logger.debug format('method not implemented yet: %s', __method__)
    nil
  end

  protected

  def sendgrid_template
    {
      event_reminder_previous_day_host: 'd-95832f343ba9477398ab411d810e4962',
      participant_creation: 'd-34fb7920b0e5459296a4712917b61498',
      participant_creation_host: 'd-068997c1fdf04ec1a3255f0260c66ba2',
      participant_creation_next_day: 'd-c8f2b65ca5fc46aa81f53cc647be154e',
      user_creation: 'd-dba1e21feb8641069f8594e3bc95b53c',
      password_reset_request: 'd-e417816d71be4f43b079182c6a44a485',
      event_creation_starrer: 'd-15acc3f9cf744c4c82726fc05cdea4c4',
      event_creation_match: 'd-28bf6c2184a641669618a5ea0f5ec9de',
      daily_digest: 'd-107e60c5b4764a8688e0313afab166a0',
      message_notification_recipient: 'd-53cbfb4b488f436689754cd93ac0b216',
      group_message_creation: 'd-fb0b31a4a0aa4ee298e96488ca9987a1'
    }
  end

  def dump_mail_template_parameters(name:)
    Utils.dump(JSON.pretty_generate(mail_template_parameters), name) if Rails.env.test?
  end

  def mail_template_parameters
    {
      recipient: @user.attributes.with_indifferent_access.slice(
        :id,
        :name,
        :last_name,
        :avatar,
        :facebook_uid,
        :fuzzy_latitude,
        :fuzzy_longitude,
        :latitude,
        :longitude,
        :activities,
        :full_address,
        :profile_blurb,
        :onboarding_care_type,
        :job_position,
        :employer,
        :highest_education,
        :school,
        :images,
        :languages
      ).update(first_name: @user.first_name&.capitalize)
    }
  end
end
