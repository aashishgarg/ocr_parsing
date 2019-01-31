module Api
  module Concerns
    module BolFileFromAttachment
      extend ActiveSupport::Concern
      # Creates the BolFile through Attachment.
      # If BolFile for attachment already exists then added into its attachments
      # else creates a new BolFile and adds the created attachment into its attachments
      def create
        @bol_files = []
        if bol_file_params[:attachments_attributes].present?
          bol_file_params[:attachments_attributes].each do |key, attachment_params|
            begin
              file_name = attachment_params[:data].original_filename.file_name
              @bol_file = current_user.bol_files.find_or_initialize_by(name: file_name)
              serial_no = attachment_params[:data].original_filename.serial_no
              attachment = @bol_file.attachments.find_or_initialize_by(serial_no: serial_no)
              _params = attachment_params.merge(serial_no: serial_no)
              attachment.new_record? ? attachment.assign_attributes(_params) : attachment.update(attachment_params)
              @bol_file.save
              @bol_files << @bol_file
            rescue => e
              @errors = {}
              @errors[e.class.to_s] = e.message
              ExceptionNotifier.notify_exception(e, data: { current_user: current_user })
            end
          end
        end
        @bol_files.uniq!
        render 'index'
      end
    end
  end
end
