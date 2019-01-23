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
          param :status, %w(0 1 2 3 4 5 6)
        end
      end

      api :GET, '/roles', 'Lists all Roles present'
      description 'Lists all Roles present'
      header 'Authentication', 'Token eyJhbGciOiJIUzI1NiJ9', required: true
      header 'Content-Type', 'application/json', required: true
      error code: 401, desc: 'Unauthorized'
      formats ['json']
      returns array_of: :role, code: 200, desc: 'Array of all Role is returned'
      def index;end

      api :GET, '/roles/:id', 'Shows a specific Role'
      desc 'Shows a specific Role'
      param :id, :name
      header 'Authentication', 'Token eyJhbGciOiJIUzI1NiJ9', required: true
      header 'Content-Type', 'application/json', required: true
      error code: 401, desc: 'Unauthorized'
      error code: 422, desc: 'Unprocessable Entity'
      formats ['json']
      returns code: 200, desc: 'Detailed information about Role' do
        param_group :role
      end
      def show;end

      api :POST, '/roles', 'Creates a new BOL File'
      desc 'Shows a specific role'
      param :role, Hash do
        param :name, String
      end
      header 'Authentication', 'Token eyJhbGciOiJIUzI1NiJ9', required: true
      header 'Content-Type', 'application/json', required: true
      error code: 401, desc: 'Unauthorized'
      error code: 422, desc: 'Unprocessable Entity'
      formats ['json']
      returns code: 200, desc: 'Detailed information about Role' do
        param_group :role
      end
      returns code: :unprocessable_entity, desc: 'Unprocessable Entity' do
        param_group :errors
      end
      def create;end

      api :PUT, '/roles/:id', 'Updates a Role'
      desc 'Updates a role'
      param :role, Hash, required: true do
        param :name, String
      end
      header 'Authentication', 'Token eyJhbGciOiJIUzI1NiJ9', required: true
      header 'Content-Type', 'application/json', required: true
      error code: 401, desc: 'Unauthorized'
      error code: 422, desc: 'Unprocessable Entity'
      formats ['json']
      returns code: 200, desc: 'Update information about Role' do
        param_group :role
      end
      returns code: :unprocessable_entity, desc: 'Unprocessable Entity' do
        param_group :errors
      end
      def update;end

      api :DELETE, '/roles/:id', 'Deletes a specific BOL File'
      desc 'Deletes a specific role'
      param :id, :name
      header 'Authentication', 'Token eyJhbGciOiJIUzI1NiJ9', required: true
      header 'Content-Type', 'application/json', required: true
      error code: 401, desc: 'Unauthorized'
      error code: 422, desc: 'Unprocessable Entity'
      formats ['json']
      def destroy;end
    end
  end
end

