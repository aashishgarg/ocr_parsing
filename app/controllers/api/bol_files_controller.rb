class Api::BolFilesController < ApplicationController
  before_action :set_bol_file, except: [:create, :index]

  def index
    @bol_files = BolFile.all # ToDo: Apply pagination
  end

  def show; end

  def create
    @bol_file = BolFile.new(bol_file_params)

    unless @bol_file.save
      render json: { errors: @bol_file.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @bol_file.update(bol_file_params)
      render 'create'
    else
      render json: { errors: @bol_file.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @bol_file.destroy
  end

  private

  def set_bol_file
    @bol_file = BolFile.find(params[:id])
  end

  def bol_file_params
    params.require(:bol_file).permit(:shipper_id, :bol_type_id, :name, :status, :ocr_parsed_data, :status_updated_by,
                                     attachments_attributes: [:data])
  end
end
