module Api
  module Docs
    module BolFilesApipie
      extend ActiveSupport::Concern
      extend Apipie::DSL::Concern

      def_param_group :errors do
        param 'errors', Hash, required: true do
          param :status, BolFile.statuses.keys
        end
      end

      api :GET, '/bol_files', 'Lists all BOL Files'
      description 'Lists all BOL Files'
      header 'Authentication', 'Token eyJhbGciOiJIUzI1NiJ9', required: true
      header 'Content-Type', 'application/json', required: true
      error code: 401, desc: 'Unauthorized'
      formats ['json']
      returns code: 200, desc: 'Array of all BOL types is returned' do
        param :bol_files, Array do
          param :index, Array do
            param :id, Integer, desc: 'Id of BOL File'
            param :name, String, desc: 'Name of BOL File'
            param :shipper_name, String, desc: 'Shipper Name of BOL File'
            param :status, BolFile.statuses.keys, desc: 'Status of BOL File'
            param :extracted_at, DateTime, desc: 'Last attachment ocr parsing time'
            param :user_id, Integer, desc: 'Status of BOL File'
            param :qa_approved_at, DateTime, desc: 'Time when it was qa_approved'
            param :released_at, DateTime, desc: 'Time when it was released'
            param :attachments, Array do
              param :index, Hash do
                param :id, Integer
                param :status, BolFile.statuses.keys, desc: 'Status of Attachment'
                param :serial_no, Integer, desc: 'Serial number of the attachment'
                param :data_file_name, String
                param :data_content_type, String
                param :data_file_size, Integer
                param :data_updated_at, DateTime
                param :ocr_parsed_data, Hash, desc: 'OCR data hash'
                param :processed_data, Hash, desc: 'Processed data of OCR'
                param :status, Attachment.statuses.keys, desc: 'Status of attachment'
                param :created_at, DateTime
                param :updated_at, DateTime
                param :url, String
              end
            end
          end
        end
        param :page_details, Hash do
          param :total_records, Integer
          param :total_pages, Integer
          param :page_number, Integer
        end
      end
      def index; end

      api :GET, '/bol_files/:id', 'Shows a specific BOL File'
      desc 'Shows a specific BOL File'
      header 'Authentication', 'Token eyJhbGciOiJIUzI1NiJ9', required: true
      header 'Content-Type', 'application/json', required: true
      param :id, :number
      error code: 401, desc: 'Unauthorized'
      error code: 422, desc: 'Unprocessable Entity'
      formats ['json']
      returns code: 200, desc: 'Bol File details' do
        param :bol_file, Hash do
          param :id, Integer, desc: 'Id of BOL File'
          param :name, String, desc: 'Name of BOL File'
          param :shipper_name, String, desc: 'Shipper Name of BOL File'
          param :status, BolFile.statuses.keys, desc: 'Status of BOL File'
          param :extracted_at, DateTime, desc: 'Status of BOL File'
          param :user_id, Integer, desc: 'Status of BOL File'
          param :qa_approved_at, DateTime, desc: 'Time when it was qa_approved'
          param :released_at, DateTime, desc: 'Time when it was released'
          param :attachments, Array do
            param :index, Hash do
              param :id, Integer
              param :status, Attachment.statuses.keys, desc: 'Status of Attachment'
              param :serial_no, Integer, desc: 'Serial ni of attachment'
              param :data_file_name, String
              param :data_content_type, String
              param :data_file_size, Integer
              param :data_updated_at, DateTime
              param :ocr_parsed_data, Hash, desc: 'OCR data hash'
              param :processed_data, Hash, desc: 'Processed data of OCR'
              param :status, Attachment.statuses.keys, desc: 'Status of attachment'
              param :created_at, DateTime
              param :updated_at, DateTime
              param :url, String
            end
          end
        end
      end
      def show; end

      api :POST, '/bol_files', 'Creates a new BOL File'
      desc 'Creates a new BOL File with its attachment file'
      header 'Authentication', 'Token eyJhbGciOiJIUzI1NiJ9', required: true
      header 'Content-Type', 'application/json', required: true
      param :bol_file, Hash, required: true do
        param :attachments_attributes, Hash, required: true do
          param :number1, Hash, required: true do
            param :data, File, required: true
          end
          param :number2, Hash, required: true do
            param :data, File, required: true
          end
          param :number3, Hash, required: true do
            param :data, File, required: true
          end
        end
      end
      error code: 401, desc: 'Unauthorized'
      error code: 422, desc: 'Unprocessable Entity'
      formats ['json']
      returns code: 200, desc: 'Array of all BOL types is returned' do
        param :bol_files, Array do
          param :index, Array do
            param :id, Integer, desc: 'Id of BOL File'
            param :name, String, desc: 'Name of BOL File'
            param :shipper_name, String, desc: 'Shipper Name of BOL File'
            param :status, BolFile.statuses.keys, desc: 'Status of BOL File'
            param :extracted_at, DateTime, desc: 'Last attachment ocr parsing time'
            param :user_id, Integer, desc: 'Status of BOL File'
            param :qa_approved_at, DateTime, desc: 'Time when it was qa_approved'
            param :released_at, DateTime, desc: 'Time when it was released'
            param :attachments, Array do
              param :index, Hash do
                param :id, Integer
                param :status, BolFile.statuses.keys, desc: 'Status of Attachment'
                param :serial_no, Integer, desc: 'Serial number of the attachment'
                param :data_file_name, String
                param :data_content_type, String
                param :data_file_size, Integer
                param :data_updated_at, DateTime
                param :ocr_parsed_data, Hash, desc: 'OCR data hash'
                param :processed_data, Hash, desc: 'Processed data of OCR'
                param :status, Attachment.statuses.keys, desc: 'Status of attachment'
                param :created_at, DateTime
                param :updated_at, DateTime
                param :url, String
              end
            end
          end
        end
        param :errors, Hash do
          param :error_class, String
        end
      end
      returns code: :unprocessable_entity, desc: 'Unprocessable Entity' do
        param_group :errors
      end
      def create; end

      api :PATCH, '/bol_files/:id', 'Updates a BOL File'
      desc 'Updates a BOL File'
      header 'Authentication', 'Token eyJhbGciOiJIUzI1NiJ9', required: true
      header 'Content-Type', 'application/json', required: true
      param :bol_file, Hash, required: true do
        param :name, String
        param :attachments_attributes, Hash do
          param :number1, Hash do
            param :id, Integer, required: true
            param :processed_data, Hash do
              param :Details, Array do
                param :Class, Hash do
                  param :value, String
                end
              end
              param :PoNumber, Hash do
                param :value, String
              end
            end
          end

          param :number1, Hash do
            param :id, Integer, required: true
            param :processed_data, Hash do
              param :Details, Array do
                param :Class, Hash do
                  param :value, String
                end
              end
              param :PoNumber, Hash do
                param :value, String
              end
            end
          end
        end
      end
      error code: 401, desc: 'Unauthorized'
      error code: 422, desc: 'Unprocessable Entity'
      formats ['json']
      returns code: 200, desc: 'Bol File details' do
        param :bol_file, Hash do
          param :id, Integer, desc: 'Id of BOL File'
          param :name, String, desc: 'Name of BOL File'
          param :shipper_name, String, desc: 'Shipper Name of BOL File'
          param :status, BolFile.statuses.keys, desc: 'Status of BOL File'
          param :extracted_at, DateTime, desc: 'Status of BOL File'
          param :user_id, Integer, desc: 'Status of BOL File'
          param :qa_approved_at, DateTime, desc: 'Time when it was qa_approved'
          param :released_at, DateTime, desc: 'Time when it was released'
          param :attachments, Array do
            param :index, Hash do
              param :id, Integer
              param :status, Attachment.statuses.keys, desc: 'Status of Attachment'
              param :serial_no, Integer, desc: 'Serial ni of attachment'
              param :data_file_name, String
              param :data_content_type, String
              param :data_file_size, Integer
              param :data_updated_at, DateTime
              param :ocr_parsed_data, Hash, desc: 'OCR data hash'
              param :processed_data, Hash, desc: 'Processed data of OCR'
              param :status, Attachment.statuses.keys, desc: 'Status of attachment'
              param :created_at, DateTime
              param :updated_at, DateTime
              param :url, String
            end
          end
        end
      end
      returns code: :unprocessable_entity, desc: 'Unprocessable Entity' do
        param_group :errors
      end
      def update; end

      api :DELETE, '/bol_files/:id', 'Deletes a specific BOL File'
      desc 'Deletes a specific BOL File'
      header 'Authentication', 'Token eyJhbGciOiJIUzI1NiJ9', required: true
      header 'Content-Type', 'application/json', required: true
      param :id, :number
      error code: 401, desc: 'Unauthorized'
      error code: 422, desc: 'Unprocessable Entity'
      formats ['json']
      def destroy; end
    end
  end
end

