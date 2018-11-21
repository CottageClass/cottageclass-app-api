Rails.application.routes.draw do
  ActiveAdmin.routes(self)

  post 'auth/user_token' => 'user_token#create'
  post 'auth/facebook' => 'facebook_token#create'

  get '/users/:id' => 'users#show'
  post '/users/:id' => 'users#update'

  get '/networks/:network_code/users' => 'users#index'

  get '/users/:id/inquiries' => 'users#inquiries', as: 'inquiries'

  post '/users/:id/proxy_sessions' => 'twilio_sessions#create', as: 'proxy_sessions'
  post '/proxy_callback' => 'twilio_sessions#callback'

  root "null#index"
end
