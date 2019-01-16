module SidekiqMediator
  extend ActiveSupport::Concern

  def perform_later(klass, *args)
    args.push(User.current)
    klass.send(:perform_later, *args)
  end
end