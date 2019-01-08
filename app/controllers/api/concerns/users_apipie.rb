module Api
  module Concerns
    module UsersApipie
      extend ActiveSupport::Concern
      extend Apipie::DSL::Concern

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

      api :GET, '/api/user/:id', 'Shows a specific User'
      desc 'Shows a specific User'
      param :id, :number
      error code: 401, desc: 'Unauthorized'
      error code: 422, desc: 'Unprocessible Entity'
      formats ['json']
      returns code: 200, desc: 'Detailed information about User' do
        param_group :user
      end
      def show; end
      
      def update; end

    end
  end
end