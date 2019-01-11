Rails.application.routes.draw do
  apipie

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  scope :api, defaults: { format: :json } do
    devise_for :users, controllers: { sessions: :sessions, registrations: :registrations },
               path_names: { sign_in: :login }
  end

  namespace :api, defaults: { format: :json } do
    resource :user, only: [:show, :update]
    resources :bol_files
  end

  root to: redirect('/apidocs')
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
