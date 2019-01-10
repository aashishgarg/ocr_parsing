Rails.application.routes.draw do
  apipie

  scope :api, defaults: { format: :json } do
    devise_for :users, controllers: { sessions: :sessions, registrations: :registrations },
               path_names: { sign_in: :login }
  end

  namespace :api, defaults: { format: :json } do
    resource :user, only: [:show, :update]
    resources :bol_files
  end
end
