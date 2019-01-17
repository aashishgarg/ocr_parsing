class SessionsController < Devise::SessionsController
  include Api::Docs::SessionsApipie
  skip_before_action :set_paper_trail_whodunnit, only: :create
  skip_authorization_check only: %i[create]

  def create
    user = User.find_by_email(sign_in_params[:email])

    if user && user.valid_password?(sign_in_params[:password])
      @current_user = user
    else
      render json: { errors: { 'email or password' => ['is invalid'] } }, status: :unprocessable_entity
    end
  end
end