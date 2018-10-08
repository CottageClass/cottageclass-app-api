class ApplicationController < ActionController::API
  include Knock::Authenticable

  def new_jwt
    Knock::AuthToken.new(payload: { sub: current_user.id }).token
  end

  # override response render to return new JWT w/ successful logged in requests
  # ref: https://codycallahan.com/blog/authenticate-rails-api-with-knock-jwt
  def render(options=nil, extra_options={}, &block)
    options ||= {}
    # if the user is logged in and we're returning a JSON object,
    # send a new JWT with it
    if json_response?(options) && logged_in?
      options[:json].merge!({jwt: new_jwt})
    end

    super(options, extra_options, &block)
  end

  private

  def json_response?(options)
    options[:json].is_a? Hash
  end

  def logged_in?
    current_user.present?
  end
end
