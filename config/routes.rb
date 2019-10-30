Rails.application.routes.draw do
  ActiveAdmin.routes self
  devise_for :users,
             controllers: {
               omniauth_callbacks: 'users/omniauth_callbacks',
               passwords: 'users/passwords',
               registrations: 'users/registrations',
               sessions: 'users/sessions'
             }

  namespace :api, defaults: { format: :json } do
    resources :devices, only: %i[create]
    resources :event_series, only: %i[index show create update]
    resources :childcare_requests, only: %i[show create update destroy]
    resources :events, only: %i[show update destroy] do
      resource :stars, only: %i[create destroy], module: :events
      resources :stars, only: %i[index], module: :events
      resources :participants, only: %i[create] do
        collection { delete :index, to: 'participants#destroy' }
      end
      collection do
        get '(/:skope)(/miles/:miles(/latitude/:latitude/longitude/:longitude))'\
          '(/min_age/:min_age)(/max_age/:max_age)'\
          '(/date/:date)(/weekday/:weekday)'\
          '(/sort/:sort)(/page/:page/page_size/:page_size)',
            to: 'events#index',
            skope: /upcoming|past/i,
            sort: /chronological|distance/i,
            latitude: /-?+(?=.??\d)\d*\.?\d*/,
            longitude: /-?+(?=.??\d)\d*\.?\d*/,
            miles: /-?+(?=.??\d)\d*\.?\d*/,  # this allows negatives, which it shouldn't
            min_age: /\d+/,
            max_age: /\d+/,
            date: /\d\d\d\d-\d\d-\d\d/,
            weekday: /\d/,
            defaults: { skope: 'all' },
            as: :index
      end
    end

    resources :users, only: %i[show] do
      resources :messages, only: %i[index create]
    end

    resources :users, only: %i[show destroy update] do
      resource :stars, only: %i[create destroy], module: :users
      resource :dark_stars, only: %i[create destroy], module: :users
      collection do
        get '/miles/:miles/latitude/:latitude/longitude/:longitude(/min_age/:min_age)(/max_age/:max_age)(/page/:page/page_size/:page_size)',
            to: 'users#feed',
            latitude: /-?+(?=.??\d)\d*\.?\d*/,
            longitude: /-?+(?=.??\d)\d*\.?\d*/,
            miles: /-?+(?=.??\d)\d*\.?\d*/,  # this allows negatives, which it shouldn't
            min_age: /\d+/,
            max_age: /\d+/,
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
    end
    resource :user, only: %i[] do
      resources :conversations, only: %i[index]
      resource :stars, only: %i[create destroy], module: :users
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
    resources :place, only: %i[] do
      resource :events, only: %i[] do
        collection do
          get '(/:skope)(/page/:page/page_size/:page_size)', to: 'events#place',
                                                             skope: /upcoming|past/i,
                                                             defaults: { skope: 'all' },
                                                             as: :place_events
        end
      end
    end
  end

  #############
  # routes for facebook crawler
  #############
  get '/event/:id', to: 'crawler_events#show', constraints: lambda { |request|
    request.user_agent && (request.user_agent.include? 'facebookexternalhit')
  }, as: 'crawler_event'

  #############
  # fallbacks
  #############

  root 'static#index'

  get '/*path', to: 'static#index', format: false
end
