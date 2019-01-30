module Debug
  def json_body
    JSON.parse response_body
  end
end

RSpec.configure do |config|
  config.include Debug
end
