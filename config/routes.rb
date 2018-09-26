Rails.application.routes.draw do
  # if problems arise see: https://github.com/lynndylanhurley/devise_token_auth/blob/master/docs/faq.md#can-i-use-this-gem-alongside-standard-devise

  #devise_for :users
  mount_devise_token_auth_for 'User', at: 'auth'

  root "null#index"
end
