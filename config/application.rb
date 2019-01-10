require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

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

    # Use Sidekiq as queuing background
    config.active_job.queue_adapter = :sidekiq

    # All jobs will run based on app environment 
    # queue production_ocr_queue on production environment
    # staging_ocr_queue on staging environment
    # development_ocr_queue on development environment
    config.active_job.queue_name_prefix = Rails.env

    # File storage on Amazon S3
    # config.active_storage.service = :amazon

    unless (Rails.env.test?)
      config.paperclip_defaults = {
        storage: :s3,
        s3_host_name: 's3.amazonaws.com',
        s3_credentials: {
          access_key_id: ENV['AWS_ACCESS_KEY_ID'],
          secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
          s3_region: "us-east-1"
        },
        bucket: ENV['AWS_BUCKET'],
        s3_permissions: :private
      }
    end
  end
end
