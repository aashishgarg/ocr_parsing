module Api
  module Concerns
    module BolFileFromAttachment
      extend ActiveSupport::Concern
      # Creates the BolFile through Attachment.
      # If BolFile for attachment already exists then added into its attachments
      # else creates a new BolFile and adds the created attachment into its attachments
      def create
        result = BolFile.provision_bulk_upload(bol_file_params, current_user)
        @bol_files = result[:bol_files].compact.uniq
        @errors = result[:errors] if result[:errors].present?
        render 'index'
      end
    end
  end
end
