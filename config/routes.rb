Rails.application.routes.draw do
  post 'auth/user_token' => 'user_token#create'
  post 'auth/facebook' => 'facebook_token#create'

  get '/users/:id' => 'users#show'
  post '/users/:id' => 'users#update'

  root "null#index"
end
