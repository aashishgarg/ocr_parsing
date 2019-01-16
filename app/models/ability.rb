class Ability
  include CanCan::Ability

  def initialize(user)
    if user.is_admin?
      can :manage, :all
    elsif user.is_support?
      can :read, User
      can :create, BolFile
      can :update, BolFile
      can :index, BolFile
      can :show, BolFile
      can :index, Api::DashboardController
      can :update, Attachment
    elsif user.is_customer?
      can :read, User
      can :update, BolFile
      can :index, BolFile
      can :show, BolFile
      can :index, Api::DashboardController
      can :update, Attachment
    end
  end
end
