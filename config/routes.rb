Rails.application.routes.draw do
  get "/sitemap.xml" => "pages#sitemap", :format => "xml", :as => :sitemap
  get 'pages/index'
  require 'sidekiq/web'
  require 'sidekiq-scheduler/web'
  mount Sidekiq::Web => '/sidekiq'
  
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'registrations' }

  authenticated :user do
    root 'albums#index', as: :authenticated_root
  end

  get 'connect', to: 'users#connect'
  get 'settings', to: 'devise/registrations#edit'
  get '/signout' => 'sessions#destroy', :as => :signout

  resources :artists do
    member do
      get 'unfollow'
      get 'follow'
    end
    collection do
      get 'search'
    end
  end

  resources :charts do
    collection do
      get 'artists'
      get 'albums'
    end
  end

  resources :users do
    collection do
      get 'import_apple_music'
    end
  end

  resources :albums do
    collection do
      get 'upcoming'
    end
  end

  resources :music_videos, path: '/music-videos'
  resources :news
  
  get '/test' => 'pages#test'
  get '/token' => 'pages#token'
  root "pages#index"
end
