class Notifier::PasswordResetRequest < Notifier::Base
  def initialize(user:, token:, body:)
    super user: user, body: body
    @token = token
  end

  def email
    dump_mail_template_parameters name: 'PasswordResetRequest.json'
    response = @sendgrid_client.send_mail to: [@user],
                                          from: @sender_email,
                                          template_id: sendgrid_template[:password_reset_request],
                                          parameters: mail_template_parameters.deep_stringify_keys

    (response.try(:headers) || {}).dig('x-message-id').try :first
  end

  def message
    Rails.logger.debug format('method not implemented: %s', __method__)
    nil
  end

  def link
    # ENV['APP_HOST'] + '/password-reset/' + @token
    ENV['LINK_HOST'] + '/password-reset/' + @token
  end

  def mail_template_parameters
    {
      link: link,
      recipient: @user.attributes.with_indifferent_access.slice(
        :id,
        :name,
        :first_name,
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
        :images,
        :languages
      )
    }
  end
end
