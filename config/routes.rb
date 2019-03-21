Rails.application.routes.draw do
  ActiveAdmin.routes self
  devise_for :users,
             # TODO: get rid of the GET user/sign_in route because it is done with vue now

             ## use better routes for auth
             # path: '',
             # path_names: {
             #   sign_in: 'login',
             #   sign_out: 'logout',
             #   registration: 'signup'
             # },
             controllers: {
               omniauth_callbacks: 'users/omniauth_callbacks',
               passwords: 'users/passwords',
               registrations: 'users/registrations',
               sessions: 'users/sessions'
             }

  namespace :api, defaults: { format: :json } do
    resources :event_series, only: %i[index show create update]
    resources :events, only: %i[show update destroy] do
      resources :participants, only: %i[create] do
        collection { delete :index, to: 'participants#destroy' }
      end
      collection do
        get '(/:skope)(/miles/:miles(/latitude/:latitude/longitude/:longitude))(/sort/:sort)'\
        '(/page/:page/page_size/:page_size)',
            to: 'events#index',
            skope: /upcoming|past/i,
            sort: /chronological|distance/i,
            latitude: /-?+(?=.??\d)\d*\.?\d*/,
            longitude: /-?+(?=.??\d)\d*\.?\d*/,
            defaults: { skope: 'all' },
            as: :index
      end
    end
    resources :users, only: %i[show] do
      collection do
        get '(/miles/:miles(/latitude/:latitude/longitude/:longitude))(/page/:page/page_size/:page_size)',
            to: 'users#index',
            latitude: /-?+(?=.??\d)\d*\.?\d*/,
            longitude: /-?+(?=.??\d)\d*\.?\d*/,
            as: :index
      end
      resources :events, only: %i[] do
        collection do
          get 'created(/:skope)(/page/:page/page_size/:page_size)', to: 'events#created',
                                                                    skope: /upcoming|past/i,
                                                                    defaults: { skope: 'all' },
                                                                    as: :created
          get 'participated(/:skope)(/page/:page/page_size/:page_size)', to: 'events#participated',
                                                                         skope: /upcoming|past/i,
                                                                         defaults: { skope: 'all' },
                                                                         as: :participated
        end
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

  # get
  get '/users/:id' => 'users#show'
  get '/users/:id/inquiries' => 'users#inquiries', as: 'inquiries'
  get '/users/:sender_id/messages/:receiver_id' => 'messages#admin_for_pair', as: 'messages_for_pair'

  get '/users' => 'users#admin_index', as: 'admin_all_users'

  # post
  post '/users/:id' => 'users#update'

  # twilio sessions
  post '/users/:id/proxy_sessions' => 'twilio_sessions#create', as: 'proxy_sessions'
  post '/proxy_callback' => 'twilio_sessions#callback'

  get '/static' => 'static#index', as: 'static'

  root 'static#index'

  get '/*path', to: 'static#index', format: false
end
