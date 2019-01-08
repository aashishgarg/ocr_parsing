module Api
  module Concerns
    module BolTypesApipie
      extend ActiveSupport::Concern
      extend Apipie::DSL::Concern

      def_param_group :bol_type do
        property :name, String, desc: 'Name of the BOL Type'
        property :id, Integer, desc: 'Id of the BOL Type'
      end

      def_param_group :errors do
        param 'errors', Hash, required: true do
          param :name, String
        end
      end

      api :GET, '/bol_types', 'Lists all BOL types present'
      description 'Lists all BOL types'
      error code: 401, desc: 'Unauthorized'
      formats ['json']
      returns array_of: :bol_type, code: 200, desc: 'Array of all BOL types is returned'
      def index;end

      api :GET, '/bol_types/:id', 'Shows a specific BOL Type'
      desc 'Shows a specific BOL Type'
      param :id, :number
      error code: 401, desc: 'Unauthorized'
      error code: 422, desc: 'Unprocessable Entity'
      formats ['json']
      returns code: 200, desc: 'Detailed information about BOL Type' do
        param_group :bol_type
      end
      def show;end

      api :POST, '/bol_types', 'Create new BOL Type'
      desc 'Create a new BOL Type'
      param :name, String, desc: 'Name of the BOL Type', required: true
      error code: 401, desc: 'Unauthorized'
      error code: 422, desc: 'Unprocessable Entity'
      formats ['json']
      returns code: 200, desc: 'Detailed information about BOL Type' do
        param_group :bol_type
      end
      returns code: :unprocessable_entity, desc: 'Unprocessable Entity', required: true do
        param_group :errors
      end
      def create;end

      api :PUT, '/bol_types/:id', 'Updates a specific BOL Type'
      desc 'Updates a specific BOL Type'
      param :id, :number, required: true
      error code: 401, desc: 'Unauthorized'
      error code: 422, desc: 'Unprocessable Entity'
      formats ['json']
      returns code: 200, desc: 'Detailed information about BOL Type' do
        param_group :bol_type
      end
      returns code: :unprocessable_entity, desc: 'Unprocessable Entity', required: true do
        param_group :errors
      end
      def update;end

      api :DELETE, '/bol_types/:id', 'Deletes a specific BOL Type'
      desc 'Deletes a specific BOL Type'
      param :id, :number, required: true
      error code: 401, desc: 'Unauthorized'
      error code: 422, desc: 'Unprocessable Entity'
      formats ['json']
      def destroy;end
    end
  end
end

