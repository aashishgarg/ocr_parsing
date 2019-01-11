web: bin/rails server -p $PORT -e $RAILS_ENV
sidekiq: bundle exec sidekiq --verbose  -C config/sidekiq.yml
release: bundle exec rake db:migrate
