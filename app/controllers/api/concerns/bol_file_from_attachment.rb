module Api
  module Concerns
    module BolFileFromAttachment
      extend ActiveSupport::Concern

      def self.included(base_class)
        base_class.class_eval do
          # Before Actions
          before_action :set_bol_file, only: %i[update]

          def create
            attachment = Attachment.new(attachment_params)
            attachment.tap do |attachment|
              @bol_file = attachment.attachable = attachment.parent
              attachment.serial_no = attachment.parsed_serial_no
            end
            attachment.save
          end

          def update

          end

          private

          def set_bol_file
          end

          def attachment_params
            params.require(:attachment).permit(:data)
          end
        end
      end
    end
  end
end
