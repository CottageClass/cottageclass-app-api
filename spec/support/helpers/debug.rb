module Debug
  def json_body
    if 'gzip'.eql?(response_headers['Content-Encoding'])
      gz = Zlib::GzipReader.new StringIO.new(response_body)
      response_body = gz.read
    end
    JSON.parse response_body
  end
end

RSpec.configure do |config|
  config.include Debug
end
