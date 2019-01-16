module Mocks
  class Twilio < Mocks::Common
    def messages_create
      account_sid = ENV.fetch 'TWILIO_ACCOUNT_SID'
      sender_number = ENV.fetch 'TWILIO_SENDER_NUMBER'

      WebMock.stub_request(:post, Regexp.compile('[^.]+api.twilio.com/[^\/]+/Accounts/[^\/]+/Messages.json'))
        .with(
          headers: {
            'Accept' => 'application/json'
          }
        )
        .to_return(
          lambda { |_|
            message_sid = format 'SM%s', Faker::Crypto.unique.md5
            {
              status: 201,
              body: JSON.generate(
                sid: message_sid,
                date_created: Time.current.rfc2822,
                date_updated: Time.current.rfc2822,
                date_sent: nil,
                account_sid: account_sid,
                to: Faker::PhoneNumber.cell_phone,
                from: sender_number,
                messaging_service_sid: nil,
                body: Faker::Lorem.sentence,
                status: 'queued',
                num_segments: '1',
                num_media: '0',
                direction: 'outbound-api',
                api_version: '2010-04-01',
                price: nil,
                price_unit: 'USD',
                error_code: nil,
                error_message: nil,
                uri: format('/2010-04-01/Accounts/%s/Messages/%s.json', account_sid, message_sid),
                subresource_uris: {
                  media: format('/2010-04-01/Accounts/%s/Messages/%s/Media.json', account_sid, message_sid)
                }
              ),
              headers: {}
            }
          }
        )
    end
  end
end

RSpec.configure do |config|
  config.before { Mocks::Twilio.new.messages_create }
end
