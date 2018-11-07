# JWT & FB AUTH CONTRACTS
#
# - our only contract with the client is via JWT
# - requests to FB are rare so all reqs to FB go through our server (and require auth from the JWT)
# - requests to FB can try looking up the saved FB/provider_token, and if expired, can create a new one
# (perhaps just create a new one every time to avoid having failed request wait time)
#
# Useful links:
# - https://github.com/nsarno/knock/issues/11
# - https://github.com/arsduo/koala/wiki/OAuth

class FacebookTokenController < ApplicationController
  # log user in using code before hitting CRUD actions
  before_action :authenticate

  # Create a JWT from a valid FB token
  # - Currently, FB token is regenerated from code each time, not saved to DB
  # - TODO: save FB token to db for subsequent data requests
  def create
    render json: auth_token, status: 201
  end

  private

  def authenticate
    unless entity.present?
      raise Knock.not_found_exception_class
    end
  end

  def auth_token
    new_jwt(entity)
  end

  def entity
    if !@entity
      data = FacebookService.fetch_data(access_token)
      @entity = User.find_or_create_by facebook_uid: data['id'] do |user|
        # the following data are passed only on create
        user.name = data['name']
        user.first_name = data['first_name']
        user.last_name = data['last_name']
        user.email = data['email']
        user.password = SecureRandom.base64(15)
      end

      # save fb access token to user
      @entity.update_facebook_access_token!(access_token, sec_til_expiry)
    end

    @entity
  end

  # exchange code for access token
  # - contains expiry date
  def access_token_info
    @access_token_info ||= oauth.get_access_token_info(auth_params[:code], { redirect_uri: auth_params[:redirect_uri]})
  end

  def access_token
    @access_token ||= access_token_info['access_token']
  end

  def sec_til_expiry
    @expiry ||= access_token_info['expires_in'].to_i
  end

  def oauth
    @oauth ||= FacebookService.oauth(auth_params[:redirect_uri])
  end

  def auth_params
    params.require(:facebook_token).permit(:code, :client_id, :redirect_uri)
  end
end
