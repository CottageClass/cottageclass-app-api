class ApiController < ActionController::API
  include Knock::Authenticable

  ADMIN_WHITELIST = [
    'holmes@cottageclass.com',
    'manisha@cottageclass.com',
    'developer@cottageclass.com',
    'asa@cottageclass.com',
  ]

  before_action do
    pp "REQ BODY"
    pp params
    pp request.body
  end

  def new_jwt(entity=current_user)
    Knock::AuthToken.new(
      payload: {
        sub: entity.id,
        email: entity.email,
        network_code: entity.try(:network_code),
      }
    )
  end

  # override response render to return new JWT w/ successful logged in requests
  # ref: https://codycallahan.com/blog/authenticate-rails-api-with-knock-jwt
  def render(options=nil, extra_options={}, &block)
    options ||= {}
    # if the user is logged in and we're returning a JSON object,
    # send a new JWT with it
    if json_response?(options) && logged_in?
      options[:json].merge!( JSON.parse(new_jwt.to_json) )
    end

    super(options, extra_options, &block)
  end

  def require_admin!
    redirect_to root_path unless ADMIN_WHITELIST.include?(current_user.email)
  end

  private

  def json_response?(options)
    options[:json].is_a? Hash
  end

  def logged_in?
    current_user.present?
  end
end
