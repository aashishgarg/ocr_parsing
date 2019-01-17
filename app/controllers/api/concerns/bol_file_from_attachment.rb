module Api
  module Concerns
    module BolFileFromAttachment
      extend ActiveSupport::Concern

      included do
        def create
          @bol_files = []
          @errors = {}
          if attachments_param[:files].present?
            attachments_param[:files].each do |key, attachment_params|
              begin
                attachment = Attachment.new(attachment_params)
                attachment.tap do |attach|
                  @bol_files << attach.attachable = attach.parent(current_user)
                  attach.serial_no = attach.parsed_serial_no
                end.save
              rescue => e
                @errors[e.message.to_s] = e.message
              end
            end
          end
          @bol_files.uniq!
          render 'index'
        end

        private

        def attachments_param
          params.require(:attachments).permit(files: [:data])
        end
      end
    end
  end
end
