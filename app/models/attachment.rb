class Attachment < ApplicationRecord
  # Attribute Accessors
  attr_accessor :ocr_data, :parsed_data

  # Modules Inclusion
  include StateMachine
  include ParentProcessor

  # Constants
  PAPERCLIP_IMAGE_CONTENT_TYPE = [/\Aimage\/.*\z/, 'application/json'].freeze
  MIME_TYPE_FOR_OCR = 'image/png'.freeze
  REQUIRED_FIELDS = %w[
    ShipperName
    ShipperAddress
    ShipperAddress2
    ShipperCity
    ShipperState
    ShipperZip
    ShipperContactPhone
    ShipperContactFax
    ShipperContactEmail
    ShipperContactName
    ConsigneeName
    ConsigneeAddress
    ConsigneeAddress2
    ConsigneeCity
    ConsigneeState
    ConsigneeZip
    ConsigneeContactPhone
    ConsigneeContactFax
    ConsigneeContactEmail
    ConsigneeContactName
    ThirdPartyName
    ThirdPartyAddress
    ThirdPartyAddress2
    ThirdPartyCity
    ThirdPartyState
    ThirdPartyZip
    ThirdPartyContactPhone
    ThirdPartyContactFax
    ThirdPartyContactEmail
    ThirdPartyContactName
    SpecialInstructions
    BolNumber
    PoNumber
    EmergencyContactInfo
    PaymentTerms
    ShipmentDate
    PreAssignedPittPro
    Pieces
    PackageType
    Weight
    Hazmat
    Description
    Class
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
  after_update :update_parent_details, if: proc { previous_changes.has_key?(:ocr_parsed_data) && previous_changes[:ocr_parsed_data][1].present? }

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
    statuses = []
    attachable.attachments.pluck(:status).each { |status| statuses << Attachment.statuses[status]}
    statuses.delete(nil)
    bol_status = (statuses.min || 0)
    attachable.method((Attachment.statuses.key(bol_status) + '!').to_sym).call
  end

  def update_bol_extracted
    attachable.update(extracted_at: updated_at) if attachable.attachments.pluck(:status).uniq == %w[ocr_done]
  end

  def update_parent_details
    attachable.update(shipper_name: ocr_parsed_data.dig('data', 'ShipperName')) if ocr_parsed_data.dig('data', 'ShipperName')
  end

  def queue_file
    ProcessFilesJob.perform_later(self)
  end
end
