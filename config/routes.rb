Rails.application.routes.draw do
  ActiveAdmin.routes(self)

  # auth
  post 'auth/user_token' => 'user_token#create'
  post 'auth/facebook' => 'facebook_token#create'

  # get
  get '/users/:id' => 'users#show'
  get '/users/:id/inquiries' => 'users#inquiries', as: 'inquiries'
  get '/users/:sender_id/messages/:receiver_id' => 'messages#admin_for_pair', as: 'messages_for_pair'

  get '/users' => 'users#admin_index', as: 'admin_all_users'
  get '/networks/:network_code/users' => 'users#index'

  # post
  post '/users/:id' => 'users#update'

  # twilio sessions
  post '/users/:id/proxy_sessions' => 'twilio_sessions#create', as: 'proxy_sessions'
  post '/proxy_callback' => 'twilio_sessions#callback'

  get '/static' => 'static#index', as: 'static'

  root "null#index"
end
