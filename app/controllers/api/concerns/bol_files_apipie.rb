module Api
  module Concerns
    module BolFilesApipie
      extend ActiveSupport::Concern
      extend Apipie::DSL::Concern

      def_param_group :attachment do
        property :id, Integer
        property :data_file_name, String
        property :data_content_type, String
        property :data_file_size, Integer
        property :data_updated_at, DateTime
        property :created_at, DateTime
        property :updated_at, DateTime
        property :url, String
      end

      def_param_group :bol_file do
        property :id, Integer, desc: 'Id of BOL File'
        property :name, String, desc: 'Name of BOL File'
        property :Status, String, desc: 'Status of BOL File'
        property :ocr_parsed_data, Hash, desc: 'Status of BOL File'
        property :attachments, Hash do
          param_group :attachment
        end
      end

      api :GET, '/api/bol_files', 'Lists all BOL Files present'
      description 'Lists all BOL Files present'
      error code: 401, desc: 'Unauthorized'
      formats ['json']
      returns array_of: :bol_file, code: 200, desc: 'Array of all BOL types is returned'
      def index;end

      api :GET, '/api/bol_files/:id', 'Shows a specific BOL File'
      desc 'Shows a specific BOL File'
      param :id, :number
      error code: 401, desc: 'Unauthorized'
      error code: 422, desc: 'Unprocessible Entity'
      formats ['json']
      returns code: 200, desc: 'Detailed information about BOL File' do
        param_group :bol_file
      end
      def show;end

      api :POST, '/api/bol_files', 'Creates a new BOL File'
      desc 'Shows a specific BOL File'
      param :bol_file, Hash do
        param :bol_type_id, Integer
        param :name, String
        param :status, String
        param :ocr_parsed_data, Hash
        param :status_updated_by, Integer
        param :status_updated_by, Integer
        param :attachments_attributes, Hash do
          param :data, String
        end
      end
      error code: 401, desc: 'Unauthorized'
      error code: 422, desc: 'Unprocessible Entity'
      formats ['json']
      returns code: 200, desc: 'Detailed information about BOL File' do
        param_group :bol_file
      end
      def create;end

      api :PUT, '/api/bol_files/:id', 'Updates a BOL File'
      desc 'Updates a BOL File'
      param :bol_file, Hash, required: true do
        param :bol_type_id, Integer
        param :name, String
        param :status, String
        param :ocr_parsed_data, Hash
        param :status_updated_by, Integer
        param :status_updated_by, Integer
        param :attachments_attributes, Hash do
          param :data, String
        end
      end
      error code: 401, desc: 'Unauthorized'
      error code: 422, desc: 'Unprocessible Entity'
      formats ['json']
      returns code: 200, desc: 'Detailed information about BOL File' do
        param_group :bol_file
      end
      def update;end

      api :DELETE, '/api/bol_files/:id', 'Deletes a specific BOL File'
      desc 'Deletes a specific BOL File'
      param :id, :number
      error code: 401, desc: 'Unauthorized'
      error code: 422, desc: 'Unprocessible Entity'
      formats ['json']
      def destroy;end
    end
  end
end

