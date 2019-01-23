class Api::RolesController < ApplicationController
  include Api::Docs::RolesApipie

  # Before Actions
  authorize_resource
  before_action :set_role, except: [:create, :index]

  def index
    @roles = Role.all # TODO: Apply pagination
    render json: @roles
  end

  def show
    render json: @role
  end

  def create
    @role = Role.new(role_params)
    if @role.save
      render json: @role
    else
      render json: { errors: @role.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @role.update(role_params)
      render 'create'
    else
      render json: { errors: @role.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @role.destroy
  end

  private

  def set_role
    @role = Role.find_by(id: params[:id])
  end

  def role_params
    params.require(:role).permit(:name)
  end
end
