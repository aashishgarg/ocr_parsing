Rails.application.routes.draw do

  scope :api, defaults: { format: :json } do
    devise_for :users, controllers: { sessions: :sessions, registrations: :registrations },
               path_names: { sign_in: :login }
  end

  namespace :api, defaults: { format: :json } do
    resource :user, only: [:show, :update]
    resources :shippers do |shipper|
      resources :bol_files
    end
    resources :bol_types
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
