require_relative './common.rb'

module Mocks
  class Sendgrid < Mocks::Common
    def send_mail
      WebMock.stub_request(:post, Regexp.compile('[^.]+api.sendgrid.com/v3/mail/send'))
        .with(
          headers: {
            'Accept' => 'application/json'
          }
        )
        .to_return(
          lambda { |_|
            {
              status: 202,
              body: JSON.generate({}),
              headers: {
                'x-message-id': Faker::Crypto.unique.md5
              }
            }
          }
        )
    end
  end
end

RSpec.configure do |config|
  config.before { Mocks::Sendgrid.new.send_mail }
end
