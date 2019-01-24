class Api::RolesController < ApplicationController
  include Api::Docs::RolesApipie

  # Before Actions
  authorize_resource
  before_action :set_role, :set_roles,  only: [:show, :destroy]
  before_action :set_roles, only: [:index, :destroy]

  def index
    render json: @roles
  end

  def show
    render json: @role
  end

  def destroy
    @role.destroy
    render json: @roles
  end

  private

  def set_role
    @role = Role.find_by(id: params[:id])
  end

  def role_params
    params.require(:role).permit(:name)
  end

  def set_roles
    @roles = @roles = Role.all # TODO: Apply pagination
  end
end
