module Api
  module Concerns
    module AttachmentsApipie
      extend ActiveSupport::Concern
      extend Apipie::DSL::Concern

      def_param_group :attachment do
        property :id, Integer
        property :data_file_name, String
        property :data_content_type, String
        property :data_file_size, Integer
        property :data_updated_at, DateTime
        property :ocr_parsed_data, Hash, desc: 'OCR data hash'
        property :processed_data, Hash, desc: 'Processed data of OCR'
        property :created_at, DateTime
        property :updated_at, DateTime
        property :url, String
      end

      def_param_group :errors do
        param 'errors', Hash, required: true do
          param :status, Attachment.statuses.keys
        end
      end

      api :PUT, '/bol_files/:bol_file_id/attachments/:id', 'Updates an Attachment'
      desc 'Updates an Attachment'
      header 'Authentication', 'Token eyJhbGciOiJIUzI1NiJ9', required: true
      header 'Content-Type', 'application/json', required: true
      param :attachment, Hash, required: true do
        param :key, String, required: true
      end
      error code: 401, desc: 'Unauthorized'
      error code: 422, desc: 'Unprocessable Entity'
      formats ['json']
      returns code: 200, desc: 'Detailed information about Attachment' do
        param_group :attachment
      end
      returns code: :unprocessable_entity, desc: 'Unprocessable Entity' do
        param_group :errors
      end
      def update; end
    end
  end
end

