class BolFile < ApplicationRecord
  # Modules Inclusions
  include Attachable
  include Statuses
  include QueryBuilder

  # Constants
  BOL_EXT = 'png'.freeze

  # Associations
  belongs_to :user, inverse_of: :bol_files
  accepts_nested_attributes_for :attachments

  # Validations
  validates :status, presence: true
  # TODO: Add file size validation

  def self.provision_bulk_upload(bol_file_params, user)
    bol_files = []
    if bol_file_params[:attachments_attributes].present?
      bol_file_params[:attachments_attributes].each do |key, attachment_params|
        begin
          file_name = attachment_params[:data].original_filename.file_name
          bol_file = user.bol_files.find_or_initialize_by(name: file_name)
          serial_no = attachment_params[:data].original_filename.serial_no
          attachment = bol_file.attachments.find_or_initialize_by(serial_no: serial_no)
          _params = attachment_params.merge(serial_no: serial_no)
          attachment.new_record? ? attachment.assign_attributes(_params) : attachment.update(attachment_params)
          bol_file.save
          bol_files << bol_file
        rescue => e
          errors = {}
          errors[e.class.to_s] = e.message
          ExceptionNotifier.notify_exception(e, data: { current_user: current_user })
        end
      end
    end
    { bol_files: bol_files, errors: (defined?(errors) ? errors : []) }
  end
end
