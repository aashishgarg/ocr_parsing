module Api
  module Concerns
    module UserApipie
      extend ActiveSupport::Concern
      extend Apipie::DSL::Concern

      def_param_group :user do
        property :id, Integer, desc: 'Id of User'
        property :email, String, desc: 'Email of User'
        property :first_name, String, desc: 'First name of User'
        property :last_name, String, desc: 'Last name of User'
        property :phone, String, desc: 'Phone of User'
        property :fax, String, desc: 'Fax of User'
      end

      def_param_group :errors do
        param 'errors', Hash, required: true do
          param :email, String
        end
      end

      api :GET, '/user', 'Shows the information about logged in user'
      desc 'Shows the information about logged in user(whose token is used for api endpoint authentication)'
      header 'Authentication', 'Token eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwiZXhwIjoxNTU', required: true
      header 'Content-Type', 'application/json', required: true
      error code: 401, desc: 'Unauthorized'
      error code: 422, desc: 'Unprocessable Entity'
      formats ['json']
      returns code: 200, desc: 'Detailed information about Logged in User' do
        param_group :user
        param :token, String, required: true
      end
      def show; end

      api :POST, '/users', 'Create a new user'
      desc 'Create a new user'
      header 'Content-Type', 'application/json', required: true
      param :users, Hash, required: true do
        param :email, String, required: true
        param :password, String, required: true
        param :first_name, String
        param :last_name, String
        param :phone, String
        param :fax, String
      end
      error code: 422, desc: 'Unprocessable Entity'
      formats ['json']
      returns code: 200, desc: 'User created Successfully' do
        param_group :user
        param :token, String, required: true
      end
      returns code: :unprocessable_entity, desc: 'Unprocessable Entity' do
        param_group :errors
      end
      def create; end

      api :PUT, '/user', 'Update the details of logged in user'
      desc 'Update the details of logged in user(whose token is used for api endpoint authentication)'
      header 'Authentication', 'Token eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwiZXhwIjoxNTU', required: true
      header 'Content-Type', 'application/json', required: true
      param :users, Hash, required: true do
        param :email, String, required: true
        param :password, String, required: true
        param :first_name, String
        param :last_name, String
        param :phone, String
        param :fax, String
      end
      error code: 401, desc: 'Unauthorized'
      error code: 422, desc: 'Unprocessable Entity'
      formats ['json']
      returns code: 200, desc: 'Detailed information about User' do
        param_group :user
      end
      returns code: :unprocessable_entity, desc: 'Unprocessable Entity' do
        param_group :errors
      end
      def update; end
    end
  end
end