class FacebookService

  def self.valid_token?(access_token)
    status = false

    # We need to check if the access_token is valid for our FB APP. Source: https://developers.facebook.com/docs/facebook-login/manually-build-a-login-flow#checktoken
    # - use app access token to new up API, so can test user access_token
    debug_token = Koala::Facebook::API
      .new(app_access_token_info['access_token'])
      .debug_token(access_token)
    status = true if debug_token['data']['is_valid']

    status
  end

  def self.fetch_data(access_token)
    if valid_token?(access_token)
       Koala::Facebook::API.new(access_token)
        .get_object('me', fields: 'name,first_name,last_name,email,picture,photos')
    end
  end

  def self.fetch_photos(access_token)
    if valid_token?(access_token)
      Koala::Facebook::API.new(access_token)
        .get_connections('me', 'photos')
    end
  end

  #https://stackoverflow.com/questions/8995035/renew-facebook-access-token-with-koala
  def self.refresh_access_token_info(access_token)
    new_token_info = oauth.exchange_access_token_info(access_token)
    new_token_info
  end

  def self.app_access_token_info
    @app_access_token ||= Koala::Facebook::OAuth.new.get_app_access_token_info
  end

  def self.get_access_token_info(code, options)
    oauth(options[:redirect_uri]).get_access_token_info(code, options)
  end

  def self.oauth(redirect_uri=Koala.config.oauth_callback_url)
    Koala::Facebook::OAuth.new(Koala.config.app_id, Koala.config.app_secret, redirect_uri)
  end

end
