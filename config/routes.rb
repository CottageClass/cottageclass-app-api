Rails.application.routes.draw do
  ActiveAdmin.routes(self)

  # auth
  post 'auth/user_token' => 'user_token#create'
  post 'auth/facebook' => 'facebook_token#create'

  # get
  get '/users/:id' => 'users#show'
  get '/networks/:network_code/users' => 'users#index'
  get '/users/:id/inquiries' => 'users#inquiries', as: 'inquiries'

  # post
  post '/users/:id' => 'users#update'

  # twilio sessions
  post '/users/:id/proxy_sessions' => 'twilio_sessions#create', as: 'proxy_sessions'
  post '/proxy_callback' => 'twilio_sessions#callback'

  get '/static' => 'static#index', as: 'static'

  root "null#index"
end
