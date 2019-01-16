module Api
  class AttachmentsController < ApplicationController
    include Api::Concerns::BolFilesApipie

    # Before Actions
    before_action :set_bol_file, only: %i[update]
    before_action :set_attachment, only: %i[update]
    authorize_resource

    def update
      data = JSON.parse(@attachment.processed_data)
      attachment_params.each { |key, value| data[key] = { value: value, status: Attachment.key_status } }
      @attachment.update(processed_data: data.to_json)
      render json: { errors: @attachment.errors }, status: :unprocessable_entity unless @attachment.valid?
    end

    private

    def set_bol_file
      @bol_file = BolFile.find_by(id: params[:bol_file_id])
      render_not_found unless @bol_file
    end

    def set_attachment
      @attachment = @bol_file.attachments.find_by(id: params[:id])
      render_not_found unless @attachment
    end

    def attachment_params
      params.require(:attachment).permit!
    end
  end
end
