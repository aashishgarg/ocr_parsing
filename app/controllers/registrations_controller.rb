class RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?
  skip_before_action :set_paper_trail_whodunnit, only: :create
  skip_authorization_check only: %i[create]

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :first_name, :last_name, :company, :phone, :fax])
  end
end