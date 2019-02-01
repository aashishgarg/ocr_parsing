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
  validates :status, presence: true, inclusion: { in: BolFile.statuses.keys }
  validates :name, uniqueness: true, presence: true

  def self.provision_bulk_upload(bol_file_params, user)
    bol_files = []
    if bol_file_params[:attachments_attributes].present?
      bol_file_params[:attachments_attributes].each do |key, attachment_params|
        begin
          retries ||= 0
          file_name = attachment_params[:data].original_filename.file_name
          bol_files << BolFile.provision(attachment_params, file_name, user)
        rescue ActiveRecord::RecordNotUnique => e
          retry if (retries += 1) < 3
          ExceptionNotifier.notify_exception(e, data: { message: 'Contact Administrator' }) if retries >= 3
        rescue => e
          errors = {}
          errors[e.class.to_s] = e.message
          ExceptionNotifier.notify_exception(e, data: { current_user: user })
        end
      end
    end
    { bol_files: bol_files, errors: (defined?(errors) ? errors : {}) }
  end

  def self.provision(params, file_name, user)
    bol_file = BolFile.find_or_initialize_by(name: file_name)
    bol_file.user = user
    serial_no = params[:data].original_filename.serial_no
    attachment = bol_file.attachments.find_or_initialize_by(serial_no: serial_no)
    _params = params.merge(serial_no: serial_no)
    attachment.new_record? ? attachment.assign_attributes(_params) : attachment.update(params)
    bol_file.save
    bol_file.valid? ? bol_file : nil
  end
end
