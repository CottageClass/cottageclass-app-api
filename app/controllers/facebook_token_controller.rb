class FacebookTokenController < ApplicationController
  # Look up user and any needed user info and log in via access token
  def facebook
    Rails.logger.info "Hit FB!"
    pp params
    #render json: auth_token, status: :created
    render json: {}, code: 200

    # add access token via Koala
    # https://github.com/arsduo/koala/wiki/OAuth
    #
    # @oauth.get_access_token(code)
    # => #{access_token}
    # or, if you want the expiration date as well:
    # @oauth.get_access_token_info(code)
    # => {"expires" => #{seconds_from_now}, "access_token" => #{access_token}}
    #
    # return a JWT
    # - save access token to the user
    # - and expire it when the user logs out (if not expired before)
    #
    # - return JWT to the user
    # - will be stored in localStorage and set as an interceptor on VueAxios
    # - FILL ME IN
    #
    # I don't believe there is any reason to have client examine the payload of the JWT, so could also store the OAuth token as the JWT;
    # - but rather store it here and send it on subseq requests to FB
    # - or just generate new token via session
    # -> Our Only Contract with the Client should be via JWT -> if you're logged in, you can get a new token anytime and send that (if your current token is expired)
    # - Basically requests to FB are rare, and so go through our servers
    #
    # OK, so send a JWT and use that for auth
    # Store these notes:
    # - our only contract with the client is via JWT
    # - requests to FB are rare so all reqs to FB go through our server (and require auth from the JWT)
    # - requests to FB can try looking up the saved FB/provider_token, and if expired, can create a new one
    # (perhaps just create a new one every time to avoid having failed request wait time)
  end
end
