Rails.application.routes.draw do
  apipie

  require "sidekiq/web"
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest('trantorinc')) &
      ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest('trantorpwd'))
  end
  mount Sidekiq::Web, at: "/sidekiq"

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
