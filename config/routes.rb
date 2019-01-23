Rails.application.routes.draw do
  apipie
  require "sidekiq/web"
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    ## ToDo change the username and password to rails credentials.
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest('trantorinc')) &
      ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest('trantorpwd'))
  end
  mount Sidekiq::Web, at: "/sidekiq"

  scope :api, defaults: { format: :json } do
    devise_for :users, controllers: { sessions: :sessions, registrations: :registrations },
               path_names: { sign_in: :login }
  end

  namespace :api, defaults: { format: :json } do
    resource :user, only: %i[show update]
    resources :roles
    resources :bol_files do
      resources :attachments, only: %i[update]
    end

    get 'dashboard', to: redirect { |_, request| "/api/bol_files?dashboard=true&#{request.query_string}" }
  end

  root to: redirect('/apidocs')
end
