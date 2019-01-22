module Api
  class BolFilesController < ApplicationController
    include Api::Docs::BolFilesApipie
    prepend Api::Concerns::BolFileFromAttachment

    # Before Actions
    authorize_resource
    before_action :set_bol_file, except: %i[create index]
    after_action :set_line_status, only: %i[update], if: proc { params[:bol_file][:attachments_attributes].present? }

    def index
      begin
        data = BolFile.data_hash(params)
      rescue FilterColumnAndValuesNotSame, FilterColumnOrValuesNotArray, ColumnNotValid => e
        errors = []
        errors << e.class.to_s
      end
      errors.present? ? render(json: { errors: errors }) : render(json: data)
    end

    def show; end

    def create
      @bol_file = current_user.bol_files.build(bol_file_params)
      render json: { errors: @bol_file.errors }, status: :unprocessable_entity unless @bol_file.save
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

    def set_line_status
      params[:bol_file][:attachments_attributes].each do |number, attachment_params|
        next if !attachment_params[:id].present? || !attachment_params[:ocr_data].present?

        attachment = @bol_file.attachments.find_by(id: attachment_params[:id])
        data = attachment.processed_data
        attachment_params[:ocr_data].each { |key, value| data[key] = { value: value, status: Attachment.key_status } }
        attachment.update(processed_data: data)
        render json: { errors: attachment.errors }, status: :unprocessable_entity unless attachment.valid?
      end
    end

    def bol_file_params
      params.require(:bol_file).permit(:bol_type_id, :name, :status, attachments_attributes: %i[id data _destroy])
    end
  end
end
