class Ability
  include CanCan::Ability

  def initialize(user)
    if user.is_admin?
      can :manage, :all
    elsif user.is_customer?
      can :read, User
    elsif user.is_support?
      can :read, User
    end
  end
end
