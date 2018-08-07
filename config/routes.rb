Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

    get 'connect', to: 'users#connect'
    get 'settings', to: 'devise/registrations#edit'
    get '/signout' => 'sessions#destroy', :as => :signout

  root "pages#index"
end
