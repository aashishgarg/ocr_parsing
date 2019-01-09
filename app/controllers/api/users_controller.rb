class Api::UsersController < ApplicationController
  include Api::Concerns::UserApipie
  # before_action :authenticate_user!

   def show
   end

  def update
    authorize! :update, User
    if current_user.update_attributes(user_params)
      render :show
    else
      render json: { errors: current_user.errors }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :first_name, :last_name, :company, :phone, :fax)
  end
end