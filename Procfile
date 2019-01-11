web: bin/rails server -p $PORT -e $RAILS_ENV
sidekiq: bundle exec sidekiq --verbose  -C config/sidekiq.yml -e $RAILS_ENV
release: bundle exec rake db:migrate
