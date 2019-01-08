module Api
  module Concerns
    module ShippersApipie
      extend ActiveSupport::Concern
      extend Apipie::DSL::Concern

      def_param_group :shipper do
        property :id, Integer, desc: 'Id of Shipper'
        property :name, String, desc: 'Name of Shipper'
        property :address1, String, desc: 'Address1 of Shipper'
        property :address2, String, desc: 'Address2 of Shipper'
        property :city, String, desc: 'City of Shipper'
        property :state, String, desc: 'State of Shipper'
        property :zip, String, desc: 'Zip of Shipper'
        property :contact_name, String, desc: 'Contact Name of Shipper'
        property :contact_email, String, desc: 'Contact Email of Shipper'
        property :contact_phone, String, desc: 'Contact Phone of Shipper'
        property :contact_fax, String, desc: 'Contact Fax of Shipper'
      end

      api :GET, '/api/shippers', 'Lists all Shippers present'
      description 'Lists all Shippers present'
      error code: 401, desc: 'Unauthorized'
      formats ['json']
      returns array_of: :shipper, code: 200, desc: 'Array of all Shippers is returned'
      def index; end

      api :GET, '/api/shippers/:id', 'Shows a specific Shipper'
      desc 'Shows a specific Shipper'
      param :id, :number
      error code: 401, desc: 'Unauthorized'
      error code: 422, desc: 'Unprocessible Entity'
      formats ['json']
      returns code: 200, desc: 'Detailed information about Shipper' do
        param_group :shipper
      end
      def show; end
      def create; end
      def update; end
      def destroy; end
    end
  end
end

