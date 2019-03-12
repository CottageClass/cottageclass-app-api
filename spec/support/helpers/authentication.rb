require 'devise/jwt/test_helpers'

module Authentication
  def authenticated_header(user)
    Devise::JWT::TestHelpers.auth_headers({}, user)
  end
end

RSpec.configure do |config|
  config.include Authentication
end
