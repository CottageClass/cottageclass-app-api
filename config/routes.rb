Rails.application.routes.draw do
  use_doorkeeper
  post 'auth/user_token' => 'user_token#create'
  post 'auth/facebook' => 'facebook_token#facebook'

  root "null#index"
end
