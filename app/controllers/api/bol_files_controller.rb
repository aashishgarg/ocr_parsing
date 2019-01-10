class Api::BolFilesController < ApplicationController
  include Api::Concerns::BolFilesApipie
  before_action :set_bol_file, except: [:create, :index]

  def index
    @bol_files = BolFile.all # ToDo: Apply pagination
  end

  def show; end

  def create
    authorize! :create, BolFile
    shipper = Shipper.find(params[:shipper_id])
    @bol_file = shipper.bol_files.new(bol_file_params)

    unless @bol_file.save
      render json: { errors: @bol_file.errors }, status: :unprocessable_entity
    end
  end

  def update
    authorize! :update, @bol_file
    if @bol_file.update(bol_file_params)
      render 'create'
    else
      render json: { errors: @bol_file.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, @bol_file
    @bol_file.destroy
  end

  private

  def set_bol_file
    @bol_file = BolFile.find(params[:id])
  end

  def bol_file_params
    params.require(:bol_file).permit(:bol_type_id, :name, :status, :ocr_parsed_data, :status_updated_by,
                                     attachments_attributes: [:data])
  end
end
