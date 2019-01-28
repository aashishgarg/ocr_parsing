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

    # File storage on Amazon S3
    # config.active_storage.service = :amazon

    # --- S3 bucket settings used by Paperclip to save files in s3 bucket --- #
    unless Rails.env.test?
      config.paperclip_defaults = {
          storage: :s3,
          s3_host_name: 's3.amazonaws.com',
          s3_credentials: {
              access_key_id: ENV['AWS_ACCESS_KEY_ID'],
              secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
              s3_region: 'us-east-1'
          },
          bucket: ENV['AWS_BUCKET']
          # ,s3_permissions: :private
      }
    end

    # --- Exceptions Emails to be delivered in Production or Staging Environment only --- #
    if Rails.env.production? || Rails.env.staging?
      config.middleware.use ExceptionNotification::Rack,
                            email: {
                              email_prefix: "[PittOhio][#{Rails.env}] ",
                              sender_address: %('Exception Notifier' <no-reply@pittohio.com>),
                              exception_recipients: %w[pitt_ohio@googlegroups.com],
                              delivery_method: :smtp,
                              deliver_with: :deliver,
                              smtp_settings: {
                                address: 'smtp.gmail.com',
                                port: 587,
                                domain: 'gmail.com',
                                user_name: 'pitttohio',
                                password: ENV['EXCEPTION_EMAIL_PASSWORD'],
                                authentication: :plain,
                                enable_starttls_auto: true
                              }
                            }
    end
  end
end
