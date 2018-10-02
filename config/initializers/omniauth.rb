# Omniauth settings for devise_token_auth
# - See: https://github.com/lynndylanhurley/devise_token_auth/blob/master/docs/config/omniauth.md#omniauth-provider-settings

Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :github,        ENV['GITHUB_KEY'],   ENV['GITHUB_SECRET'],   scope: 'email,profile'
  #provider :facebook,      ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET']
  #provider :google_oauth2, ENV['GOOGLE_KEY'],   ENV['GOOGLE_SECRET']
end
