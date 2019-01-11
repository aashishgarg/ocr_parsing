Apipie.configure do |config|
  config.app_name = 'Pittohio'
  config.copyright = ''
  config.doc_base_url = '/apidocs'
  config.api_base_url = '/api'
  config.validate = false
  config.default_version = ''
  config.app_info = 'PittOhio API Endpoints Documentation'
  config.translate = false
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
  config.authenticate = Proc.new do
    authenticate_or_request_with_http_basic do |username, password|
      username == 'trantorinc' && password == 'trantorpwd'
    end
  end
end
