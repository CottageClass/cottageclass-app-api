Rails.application.routes.draw do
  post 'auth/user_token' => 'user_token#create'
  post 'auth/facebook' => 'facebook_token#create'

  root "null#index"
end
