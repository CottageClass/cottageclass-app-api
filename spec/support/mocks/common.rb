module Mocks
  class Common
    protected

    def stub_api_request(method:, path:, params:, response:, timeout: false)
      if timeout == true
        stub_timeout method, Regexp.compile(path)
      else
        stub_request method, Regexp.compile(path), params, response
      end
    end

    def stub_timeout(method, path)
      WebMock.stub_request(method, Regexp.compile(path)).to_timeout
    end

    def stub_request(method, url, params, response)
      WebMock.stub_request(method, url)
        .with(params)
        .to_return(
          status: response[:status],
          body: JSON.generate(response[:body]),
          headers: response[:headers] || { 'Content-Type' => 'application/json' }
        )
    end
  end
end
