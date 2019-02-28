class BolFile < ApplicationRecord
  # Attribute Accessors
  attr_accessor :annotations_required

  # Modules Inclusions
  include Attachable
  include Statuses
  include QueryBuilder

  # Constants
  BOL_EXT = 'png'.freeze

  # Associations
  belongs_to :user, inverse_of: :bol_files
  accepts_nested_attributes_for :attachments

  # Callbacks
  after_update_commit :update_datetime, if: proc { previous_changes.key?(:status) }

  # Validations
  validates :status, presence: true, inclusion: { in: BolFile.statuses.keys }
  validates :name, uniqueness: true, presence: true

  def annotations
    ANNOTATIONS.select { |json| json['Shipper Name'] == shipper_name.delete("\n")&.strip }.first || {}
  end

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
          ExceptionNotifier.notify_exception(e, data: { message: 'Contact Administrator for Bol file creation' }) if retries >= 3
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

  private

  def update_datetime
    value = previous_changes[:status].last
    if BolFile.statuses[value] < BolFile.statuses['qa_approved']
      update(qa_approved_at: nil, released_at: nil)
    elsif value == 'qa_approved'
      update(qa_approved_at: DateTime.now, released_at: nil)
    elsif value == 'released'
      update(released_at: DateTime.now)
    elsif BolFile.statuses[value].between?(BolFile.statuses['qa_approved'], BolFile.statuses['released'])
      update(released_at: nil)
    end
  end
end
