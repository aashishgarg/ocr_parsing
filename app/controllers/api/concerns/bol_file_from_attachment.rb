module Api
  module Concerns
    module BolFileFromAttachment
      extend ActiveSupport::Concern

      included do
        # Creates the BolFile through Attachment.
        # If BolFile for attachment already exists then added into its attachments
        # else creates a new BolFile and adds the created attachment into its attachments
        def create
          @bol_files = []
          @errors = {}
          if bol_file_params[:attachments_attributes].present?
            bol_file_params[:attachments_attributes].each do |key, attachment_params|
              begin
                attachment = Attachment.find_or_initialize_by(data_file_name: attachment_params[:data].original_filename)
                attachment.assign_attributes(attachment_params)
                attachment.tap do |attach|
                  @bol_files << attach.attachable = attach.parent(current_user)
                  attach.serial_no = attach.parsed_serial_no
                end.save
              rescue => e
                @errors[e.class.to_s] = e.message
              end
            end
          end
          @bol_files.uniq!
          render 'index'
        end
      end
    end
  end
end
