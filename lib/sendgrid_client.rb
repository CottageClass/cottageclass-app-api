class SendgridClient
  include SendGrid

  def initialize
    @sendgrid = SendGrid::API.new api_key: ENV.fetch('SENDGRID_API_KEY'), host: 'https://api.sendgrid.com'
  end

  def send_mail(to:, from:, template_id:, parameters: {})
    mail = SendGrid::Mail.new
    mail.from = Email.new(email: from.email, name: from.name)
    mail.template_id = template_id

    personalization = Personalization.new
    to.each do |recipient|
      # [TODO] replace with recipient.email after testing
      personalization.add_to Email.new(email: ENV.fetch('OVERRIDE_RECIPIENT_EMAIL'), name: recipient.name)
    end
    personalization.add_dynamic_template_data parameters
    mail.add_personalization personalization

    @sendgrid.client.mail._('send').post request_body: mail.to_json
  end
end
