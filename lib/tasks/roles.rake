namespace :roles do
  desc 'Creates Role master'
  task create: :environment do
    Role::ALL.each { |role| Role.create(name: role) unless Role.find_by(name: role).present? }
  end
end
