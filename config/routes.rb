Rails.application.routes.draw do
  apipie
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  scope :api, defaults: { format: :json } do
    devise_for :users, controllers: { sessions: :sessions, registrations: :registrations },
               path_names: { sign_in: :login }
  end

  namespace :api, defaults: { format: :json } do
    resource :user, only: %i[show update]
    resources :bol_files do
      resources :attachments, only: %i[update]
    end
    resources :dashboard, only: [:index]
  end

  root to: redirect('/apidocs')
end
