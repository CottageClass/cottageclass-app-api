Rails.application.routes.draw do
  ActiveAdmin.routes self

  namespace :api, defaults: { format: :json } do
    resources :event_series, only: %i[index show create]
    resources :events, only: %i[show update destroy] do
      resources :participants, only: %i[create] do
        collection { delete :index, to: 'participants#destroy' }
      end
      collection do
        get '(/:skope)(/miles/:miles(/latitude/:latitude/longitude/:longitude))(/page/:page/page_size/:page_size)',
            to: 'events#index',
            skope: /upcoming|past/i,
            latitude: /-?+(?=.??\d)\d*\.?\d*/,
            longitude: /-?+(?=.??\d)\d*\.?\d*/,
            defaults: { skope: 'all' },
            as: :index
      end
    end
    resources :users, only: %i[] do
      collection do
        get '(/miles/:miles(/latitude/:latitude/longitude/:longitude))(/page/:page/page_size/:page_size)',
            to: 'users#index',
            latitude: /-?+(?=.??\d)\d*\.?\d*/,
            longitude: /-?+(?=.??\d)\d*\.?\d*/,
            as: :index
      end
      resources :notifications, only: %i[create]
    end
    resource :user, only: %i[] do
      resources :children, only: %i[update]
      collection do
        get 'created_events(/:skope)(/page/:page/page_size/:page_size)', to: 'events#created',
                                                                         skope: /upcoming|past/i,
                                                                         defaults: { skope: 'all' },
                                                                         as: :created_events
        get 'participated_events(/:skope)(/page/:page/page_size/:page_size)', to: 'events#participated',
                                                                              skope: /upcoming|past/i,
                                                                              defaults: { skope: 'all' },
                                                                              as: :participated_events
      end
    end
  end

  # auth
  post 'auth/login' => 'user_token#create'
  post 'auth/register' => 'users#create'
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

  root 'null#index'
end
