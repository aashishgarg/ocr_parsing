# Add middleware to handle CORS since frontend and backend have different domains
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins ENV.fetch('FRONTEND_DOMAIN') { 'https://petuum.herokuapp.com' }
    resource '*', headers: :any, methods: %i[get post put patch delete options head]
  end
end
