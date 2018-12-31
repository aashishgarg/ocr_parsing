require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Load ENV vars
Dotenv::Railtie.load

module Pittohio
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # API-only app
    config.api_only = true

    # Make sure to configure the server to support these options following
    # the instructions in the Rack::Sendfile documentation.
    config.action_dispatch.x_sendfile_header = "X-Accel-Redirect"

    # File storage on Amazon S3
    config.active_storage.service = :amazon
  end
end
