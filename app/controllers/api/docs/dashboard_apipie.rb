module Api
  module Docs
    module DashboardApipie
      extend ActiveSupport::Concern
      extend Apipie::DSL::Concern

      api :GET, '/dashboard', 'Lists all dashboard data'
      description 'Lists all dashboard data'
      header 'Authentication', 'Token eyJhbGciOiJIUzI1NiJ9', required: true
      header 'Content-Type', 'application/json', required: true
      param :filter_column, Array, desc: 'List of columns for data filtering'
      param :filter_value, Array, desc: 'Array of values in the same sequence as filter_columns'
      param :order_column, String, desc: 'Column for ordering of data'
      param :order, %w[asc desc], desc: 'Ordering rule'
      param :page, Integer, desc: 'Page number for records'
      param :per_page, Integer, desc: 'Records required per page'
      error code: 401, desc: 'Unauthorized'
      formats ['json']
      returns code: 200, desc: 'Data for dashboard' do
        param :data, Array do
          param :index, Hash do
            param :id, Integer, desc: 'Id of BOL File'
            param :bol_type_id, Integer, desc: 'Id of BOL type'
            param :name, String, desc: 'Name of BOL File'
            param :status, BolFile.statuses.keys, desc: 'Status of BOL File'
            param :extracted_at, DateTime, desc: 'Status of BOL File'
            param :user_id, Integer, desc: 'Status of BOL File'
          end
        end
        param :counts, Hash do
          param :total, Integer
          param :total_pages, Integer
          param :file_verified, Integer
          param :ocr_done, Integer
          param :waiting_for_approval, Integer
          param :file_approved, Integer
        end
      end
      def index; end
    end
  end
end

