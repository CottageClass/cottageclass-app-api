class Notifier::Base
  def initialize(user:, body:)
    @user = user
    @body = body

    @twilio_client = Twilio::REST::Client.new ENV.fetch('TWILIO_ACCOUNT_SID'), ENV.fetch('TWILIO_AUTH_TOKEN')
    @sendgrid_client = SendgridClient.new

    @sender_phone = ENV.fetch 'TWILIO_SENDER_NUMBER'
    @sender_email = OpenStruct.new email: Rails.configuration.x.noreply_email, name: 'KidsClub.io'

    # [TODO] replace with user.phone after testing
    @user_phone = ENV.fetch 'OVERRIDE_RECIPIENT_PHONE'
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
end
