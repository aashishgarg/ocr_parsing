class Ability
  include CanCan::Ability

  def initialize(user)
    if user.is_admin?
      can :manage, :all
    elsif user.is_support?
      can :read, User
      can :create, BolFile
      can :update, BolFile
    elsif user.is_customer?
      can :read, User
      can :update, BolFile
    end
  end
end
