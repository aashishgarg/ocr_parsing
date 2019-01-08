Apipie.configure do |config|
  config.app_name = 'Pittohio'
  config.copyright = ''
  config.doc_base_url = '/apipie'
  config.api_base_url = '/api'
  config.validate = false
  config.default_version = '1.0'
  config.app_info = 'Pittohio API endpoints for version 1.0'
  config.translate = false
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
  config.authenticate = Proc.new do
    authenticate_or_request_with_http_basic do |username, password|
      username == 'pittohio' && password == 'password'
    end
  end
end
