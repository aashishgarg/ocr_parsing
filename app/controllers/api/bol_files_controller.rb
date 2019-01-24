module Api
  class BolFilesController < ApplicationController
    include Api::Docs::BolFilesApipie
    include Api::Docs::DashboardApipie
    prepend Api::Concerns::BolFileFromAttachment

    # Before Actions
    authorize_resource
    before_action :set_bol_file, except: %i[create index]

    def index
      begin
        data = BolFile.data_hash(params)
      rescue FilterColumnAndValuesNotSame, FilterColumnOrValuesNotArray, ColumnNotValid => e
        errors = []
        errors << e.class.to_s
        ExceptionNotifier.notify_exception(e, data: { current_user: current_user })
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

    def bol_file_params
      whitelisted_processed_keys = {}
      whitelisted_processed_keys[:Details] = []
      processed_keys = Attachment::REQUIRED_HASH.dup
      details = processed_keys.delete(:Details)
      processed_keys.keys.each { |key| whitelisted_processed_keys[key] = [:value] }
      details[0].keys.each { |key| whitelisted_processed_keys[:Details] << { key => [:value] } }

      params.require(:bol_file).permit(:bol_type_id,
                                       :name,
                                       :status,
                                       attachments_attributes: [
                                         :id,
                                         :data,
                                         :_destroy,
                                         { processed_data: whitelisted_processed_keys }
                                       ])
    end
  end
end
