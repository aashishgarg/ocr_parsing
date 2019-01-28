module Api
  module Docs
    module RolesApipie
      extend ActiveSupport::Concern
      extend Apipie::DSL::Concern

      def_param_group :role do
        property :id, Integer, desc: 'Id of Role'
        property :name, String, desc: 'Name of Role'
      end

      def_param_group :errors do
        param 'errors', Hash, required: true do

        end
      end

      api :GET, '/roles', 'Lists all Roles present'
      description 'Lists all Roles present'
      header 'Authentication', 'Token eyJhbGciOiJIUzI1NiJ9', required: true
      header 'Content-Type', 'application/json', required: true
      error code: 401, desc: 'Unauthorized'
      formats ['json']
      returns array_of: :role, code: 200, desc: 'Array of all Role is returned'
      def index; end

      api :GET, '/roles/:id', 'Shows a specific Role'
      description 'Shows a specific Role'
      param :id, Integer
      param :id, String
      header 'Authentication', 'Token eyJhbGciOiJIUzI1NiJ9', required: true
      header 'Content-Type', 'application/json', required: true
      error code: 401, desc: 'Unauthorized'
      error code: 422, desc: 'Unprocessable Entity'
      formats ['json']
      returns code: 200, desc: 'Detailed information about Role' do
        param_group :role
      end
      def show; end

      api :DELETE, '/roles/:id', 'Deletes a specific Role'
      desc 'Deletes a specific role'
      param :id, Integer
      param :id, String
      header 'Authentication', 'Token eyJhbGciOiJIUzI1NiJ9', required: true
      header 'Content-Type', 'application/json', required: true
      error code: 401, desc: 'Unauthorized'
      error code: 422, desc: 'Unprocessable Entity'
      formats ['json']
      def destroy; end
    end
  end
end

