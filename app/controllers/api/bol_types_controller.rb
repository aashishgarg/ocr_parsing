class Api::BolTypesController < ApplicationController
  include Api::Concerns::BolTypesApipie
  before_action :set_bol_type, except: [:create, :index]

  def index
    @bol_types = BolType.all # ToDo: Apply pagination
  end

  def show; end

  def create
    @bol_type = BolType.new(bol_type_params)

    unless @bol_type.save
      render json: { errors: @bol_type.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @bol_type.update(bol_type_params)
      render 'create'
    else
      render json: { errors: @bol_type.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @bol_type.destroy
  end

  private

  def set_bol_type
    @bol_type = BolType.find(params[:id])
  end

  def bol_type_params
    # ToDo: Remove shipper_id from model if not needed
    params.require(:bol_type).permit(:name)
  end
end
