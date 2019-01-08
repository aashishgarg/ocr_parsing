module Api
  module Concerns
    module BolTypesApipie
      extend ActiveSupport::Concern
      extend Apipie::DSL::Concern

      def_param_group :bol_type do
        property :name, String, desc: 'Name of the BOL Type'
        property :id, Integer, desc: 'Id of the BOL Type'
      end

      api :GET, '/api/bol_types', 'Lists all BOL types present'
      description 'Lists all BOL types present in the system'
      error code: 401, desc: 'Unauthorized'
      formats ['json']
      returns array_of: :bol_type, code: 200, desc: 'Array of all BOL types is returned'
      def index;end

      api :GET, '/api/bol_types/:id', 'Shows a specific BOL Type'
      desc 'Shows a specific BOL Type'
      param :id, :number
      error code: 401, desc: 'Unauthorized'
      error code: 422, desc: 'Unprocessible Entity'
      formats ['json']
      returns code: 200, desc: 'Detailed information about BOL Type' do
        param_group :bol_type
      end
      def show;end

      api :POST, '/api/bol_types', 'Create new BOL Type'
      desc 'Create a new BOL Type'
      param :name, String, desc: 'Name of the BOL Type', required: true
      error code: 401, desc: 'Unauthorized'
      error code: 422, desc: 'Unprocessible Entity'
      formats ['json']
      returns code: 200, desc: 'Detailed information about BOL Type' do
        param_group :bol_type
      end

      def create;end

      def update;end

      def destroy;end
    end
  end
end

