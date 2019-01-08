Apipie.configure do |config|
  config.app_name = 'Pittohio'
  config.copyright = ''
  config.doc_base_url = '/apipie'
  config.api_base_url = '/api'
  config.validate = false
  config.default_version = '1.0'
  config.app_info['1.0'] = 'Pittohio API endpoints for version 1.0'
  config.translate = false
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
end
