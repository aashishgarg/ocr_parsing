module Api
  module Concerns
    module BolFileFromAttachment
      extend ActiveSupport::Concern

      included do
        def create
          @bol_files = []
          @errors = {}
          if bol_file_params[:attachments_attributes].present?
            bol_file_params[:attachments_attributes].each do |key, attachment_params|
              begin
                attachment = Attachment.new(attachment_params)
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