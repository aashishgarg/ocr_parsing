module Api
  module Concerns
    module DashboardApipie
      extend ActiveSupport::Concern
      extend Apipie::DSL::Concern

      def_param_group :dashboard_params do
        property :data, Hash do
          property :id, Integer, desc: 'Id of BOL File'
          property :name, String, desc: 'Name of BOL File'
          property :bol_type_id, Integer, desc: 'Name of BOL File'
          property :status, BolFile.statuses.keys, desc: 'Status of BOL File'
        end
      end

      api :GET, '/dashboard', 'Lists all dashboard data'
      description 'Lists all dashboard data'
      header 'Authentication', 'Token eyJhbGciOiJIUzI1NiJ9', required: true
      header 'Content-Type', 'application/json', required: true
      error code: 401, desc: 'Unauthorized'
      formats ['json']
      returns array_of: :dashboard_params, code: 200, desc: 'Data for dashboard'
      def index; end
    end
  end
end

