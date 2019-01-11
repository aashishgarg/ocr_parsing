web: bin/rails server -p $PORT -e $RAILS_ENV
sidekiq: bundle exec sidekiq -C config/sidekiq.yml
release: bundle exec rake db:migrate
