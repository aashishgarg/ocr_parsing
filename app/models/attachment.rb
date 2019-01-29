class Attachment < ApplicationRecord
  # Attribute Accessors
  attr_accessor :processor
  attr_reader :signed_original_url
  attr_reader :signed_processed_url

  # Modules Inclusion
  include StateMachine
  include ParentProcessor
  include CustomRule

  # Constants
  PAPERCLIP_IMAGE_CONTENT_TYPE = [/\Aimage\/.*\z/, 'application/json'].freeze
  MIME_TYPE_FOR_OCR = 'image/png'.freeze
  REQUIRED_HASH = {
    ShipperName: nil,
    ShipperAddress: nil,
    ShipperCity: nil,
    ShipperState: nil,
    ShipperZip: nil,
    ShipperContactPhone: nil,
    ShipperContactFax: nil,
    ShipperContactEmail: nil,
    ShipperContactName: nil,
    ConsigneeName: nil,
    ConsigneeAddress: nil,
    ConsigneeAddress2: nil,
    ConsigneeCity: nil,
    ConsigneeState: nil,
    ConsigneeZip: nil,
    ConsigneeContactPhone: nil,
    ConsigneeContactFax: nil,
    ConsigneeContactEmail: nil,
    ConsigneeContactName: nil,
    ThirdPartyName: nil,
    ThirdPartyAddress: nil,
    ThirdPartyAddress2: nil,
    ThirdPartyCity: nil,
    ThirdPartyState: nil,
    ThirdPartyZip: nil,
    ThirdPartyContactPhone: nil,
    ThirdPartyContactFax: nil,
    ThirdPartyContactEmail: nil,
    ThirdPartyContactName: nil,
    SpecialInstructions: nil,
    BolNumber: nil,
    PoNumber: nil,
    EmergencyContactInfo: nil,
    PaymentTerms: nil,
    ShipmentDate: nil,
    PreAssignedPittPro: nil,
    Details: [
      {
        "Pieces": nil,
        "PackageType": nil,
        "Weight": nil,
        "Hazmat": nil,
        "Description": nil,
        "Class": nil
      }
    ]
  }.freeze

  # Associations
  belongs_to :attachable, polymorphic: true
  has_attached_file :data, styles: lambda { |attachment| attachment.instance.process_image_type }

  # Validations
  validates_attachment_presence :data
  validates_attachment :data, content_type: { content_type: PAPERCLIP_IMAGE_CONTENT_TYPE }

  # Callbacks
  after_create_commit :queue_file
  after_update :set_bol_status, if: proc { previous_changes.has_key?(:status) }
  after_update :update_parent_details, if: proc { previous_changes.has_key?(:ocr_parsed_data) && previous_changes[:ocr_parsed_data][1].present? }
  before_update :adjust_keys, if: proc { changes.key?(:processed_data) && changes[:processed_data][0].present? }

  def path
    data.path
  end

  def self.key_status
    User.current.is_customer? || User.current.is_admin? ? 'uat_approved' : 'qa_approved'
  end

  def process_image_type
    if data_content_type.eql?(MIME_TYPE_FOR_OCR)
      { original: {} }
    else
      { processed: { format: Rack::Mime::MIME_TYPES.invert[MIME_TYPE_FOR_OCR].delete('.') } }
    end
  end

  def signed_original_url
    data.expiring_url(ENV['URL_EXPIRATION_TIME'].to_i)
  end

  def signed_processed_url
    data_content_type.eql?('image/png') ? signed_original_url : data.expiring_url(ENV['URL_EXPIRATION_TIME'].to_i, :processed)
  end

  private

  def set_bol_status
    statuses = []
    attachable.attachments.pluck(:status).each { |status| statuses << Attachment.statuses[status]}
    attachable.method((Attachment.statuses.key(statuses.min) + '!').to_sym).call
  end

  def update_bol_extracted
    attachable.update(extracted_at: updated_at) if attachable.attachments.pluck(:status).uniq == %w[ocr_done]
  end

  def update_parent_details
    attachable.update(shipper_name: ocr_parsed_data.dig('data', 'ShipperName')) if ocr_parsed_data.dig('data', 'ShipperName')
  end

  def queue_file
    ProcessFilesJob.perform_later(self, User.current)
  end

  def adjust_keys
    processed_data_changes = changes[:processed_data][1]
    details = processed_data_changes.delete(:Details)
    processed_data_changes.each do |key, value|
      status = processed_data_changes[key][:Status]
      if status.present? && !status.in?(Attachment.statuses)
        attachable.errors.add(:processed_data, "status not in #{Attachment.statuses.keys.to_sentence}")
        throw(:abort)
      end
    end
    if details.present?
      details.map! do |hash|
        hash.each do |key, value|
          status = hash[key][:Status]
          if status.present? && !status.in?(Attachment.statuses)
            attachable.errors.add(:processed_data, "status not in #{Attachment.statuses.keys.to_sentence}")
            throw(:abort)
          end
        end
      end
      processed_data_changes[:Details] = details
    end
    self.processed_data = changes[:processed_data][0].merge(processed_data_changes)
  end

  def raise_exception
    begin
      message = "Parsing failed at ocr with response code #{processor.response.code} due to '#{processor.response.body}'"
      raise FailedAtOcr, message
    rescue FailedAtOcr => e
      ExceptionNotifier.notify_exception(e, data: { attachment: self,
                                                    bol_file: attachable,
                                                    current_user: User.current,
                                                    message: e.message,
                                                    processor: processor })
    end
  end
end
