class Attachment < ApplicationRecord
  # Attribute Accessors
  attr_accessor :ocr_data, :parsed_data

  # Modules Inclusion
  include StateMachine
  include ParentProcessor

  # Constants
  PAPERCLIP_IMAGE_CONTENT_TYPE = [/\Aimage\/.*\z/, 'application/json'].freeze
  MIME_TYPE_FOR_OCR = 'image/png'.freeze
  REQUIRED_FIELDS = [
    'shipperName',
    'shipper Address',
    'shipperState',
    'shipperZip',
    'consigneeName',
    'consigneeAddress',
    'consigneeCity',
    'consigneeState',
    'consignee Zip',
    'consignee Contact Phone',
    'special Instructions',
    'emergencyContactInfo',
    'Table'
  ].freeze

  # Associations
  belongs_to :attachable, polymorphic: true
  has_attached_file :data,
                    styles: lambda { |attachment|
                      attachment.instance.process_image_type
                    },
                    processors: [:ocr]

  # Validations
  validates_attachment_presence :data
  validates_attachment :data, content_type: { content_type: PAPERCLIP_IMAGE_CONTENT_TYPE }

  # Callbacks
  after_create_commit :queue_file
  after_update :set_bol_status, if: proc { previous_changes.has_key?(:status) }

  def path
    data.path
  end

  def self.key_status
    (User.current.is_customer? || User.current.is_admin?) ? 'uat_approved' : 'qa_approved'
  end

  def process_image_type
    if data_content_type.eql?(MIME_TYPE_FOR_OCR)
      { original: {} }
    else
      { processed: { format: Rack::Mime::MIME_TYPES.invert[MIME_TYPE_FOR_OCR].delete('.') } }
    end
  end

  private

  def set_bol_status
    bol_status = []
    attachable.attachments.pluck(:status).each { |status| bol_status << Attachment.statuses[status]}
    attachable.method((Attachment.statuses.key(bol_status.min) + '!').to_sym).call
  end

  def update_bol_extracted
    attachable.update(extracted_at: updated_at) if attachable.attachments.pluck(:status).uniq == %w[ocr_done]
  end

  def queue_file
    ProcessFilesJob.perform_later(self)
  end
end
