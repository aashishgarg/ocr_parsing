module Api
  module Concerns
    module BolFileFromAttachment
      extend ActiveSupport::Concern

      included do
        def create
          @bol_files = []
          attachments_param[:file].each do |key, attachment_params|
            attachment = Attachment.new(attachment_params)
            attachment.tap do |attach|
              @bol_files << attach.attachable = attach.parent
              attach.serial_no = attach.parsed_serial_no
            end.save
          end
          @bol_files.uniq!
          render 'index'
        end

        private

        def attachments_param
          params.require(:attachments).permit(file: [:data])
        end
      end
    end
  end
end
