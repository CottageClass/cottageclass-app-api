class Notifier::Base
  def initialize(user:, body:)
    @user = user
    @body = body

    @twilio_client = Twilio::REST::Client.new ENV.fetch('TWILIO_ACCOUNT_SID'), ENV.fetch('TWILIO_AUTH_TOKEN')
    @sendgrid_client = SendgridClient.new

    @sender_phone = ENV.fetch 'TWILIO_SENDER_NUMBER'
    @sender_email = OpenStruct.new email: Rails.configuration.x.noreply_email, name: 'KidsClub.io'

    @user_phone = user.try :phone
  end

  def transmit
    {
      message: message,
      email: email
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

  def dump_mail_template_parameters(name:)
    if Rails.env.test?
      File.open(Rails.root.join(name), 'w') do |f|
        f.write JSON.pretty_generate(mail_template_parameters)
      end
    end
  end

  def mail_template_parameters
    {
      recipient: @user.attributes.with_indifferent_access.slice(
        :id,
        :name,
        :first_name,
        :last_name,
        :avatar,
        :facebook_id,
        :fuzzy_latitude,
        :fuzzy_longitude,
        :activities,
        :full_address,
        :network_code,
        :profile_blurb,
        :onboarding_care_type,
        :job_position,
        :employer,
        :highest_education,
        :school,
        :instagram_user,
        :twitter_user,
        :linkedin_user,
        :images,
        :languages
      )
    }
  end
end
