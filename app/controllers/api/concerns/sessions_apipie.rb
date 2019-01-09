module Api
  module Concerns
    module SessionsApipie
      extend ActiveSupport::Concern
      extend Apipie::DSL::Concern

      def_param_group :user do
        property :id, Integer, desc: 'Id of User'
        property :email, String, desc: 'Email of User'
        property :first_name, String, desc: 'First name of User'
        property :last_name, String, desc: 'Last name of User'
        property :company, String, desc: 'Company of User'
        property :phone, String, desc: 'Phone of User'
        property :fax, String, desc: 'Fax of User'
      end

      def_param_group :errors do
        param 'errors', Hash, required: true do
          param 'email or password', ['is invalid']
        end
      end

      api :GET, '/api/users/login', 'Login Endpoint'
      description 'Login Endpoint'
      header 'Authentication', 'Token eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwiZXhwIjoxNTU', required: true
      error code: 401, desc: 'Unauthorized'
      error code: 422, desc: 'Unprocessable Entity'
      formats ['json']
      returns code: :ok, desc: 'Detailed information about User' do
        param_group :user
      end
      returns code: :unprocessable_entity, desc: 'Unprocessable Entity' do
        param_group :errors
      end
      def create;end
    end
  end
end