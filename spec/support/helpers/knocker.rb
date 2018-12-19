module Knocker
  def authenticated_header(user)
    token = Knock::AuthToken.new(payload: { sub: user.id }).token

    {
      'Authorization': "Bearer #{token}"
    }
  end
end

RSpec.configure do |config|
  config.include Knocker
end
