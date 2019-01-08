module Api
  module Concerns
    module UserApipie
      extend ActiveSupport::Concern
      extend Apipie::DSL::Concern

      def self.superclass
        UsersController
      end

      resource_description do
        resource_id 'Users'
        description 'Users'
        api_version 'development'
      end

      def_param_group :user do
        property :id, Integer, desc: 'Id of User'
        property :email, String, desc: 'Email of User'
        property :encrypted_password, String, desc: 'Password of User'
        property :first_name, String, desc: 'First name of User'
        property :last_name, String, desc: 'Last name of User'
        property :company, String, desc: 'Company of User'
        property :phone, String, desc: 'Phone of User'
        property :fax, String, desc: 'Fax of User'
      end

      def_param_group :errors do
        param 'errors', Hash, required: true do
          param :email, String
        end
      end

      api :GET, '/user', 'Shows a specific User'
      desc 'Shows a specific User'
      error code: 401, desc: 'Unauthorized'
      error code: 422, desc: 'Unprocessible Entity'
      formats ['json']
      returns code: 200, desc: 'Detailed information about User' do
        param_group :user
      end
      def show; end

      api :PUT, '/user', 'Update a user'
      desc 'Update a user'
      error code: 401, desc: 'Unauthorized'
      error code: 422, desc: 'Unprocessible Entity'
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