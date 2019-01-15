class Attachment < ApplicationRecord
  # Constants
  REQUIRED_FIELDS = ['shipperName', 'shipper Address', 'shipperState', 'shipperZip', 'consigneeName', 'consigneeAddress',
                'consigneeCity', 'consigneeState', 'consignee Zip', 'consignee Contact Phone', 'special Instructions',
                'emergencyContactInfo', 'Table'].freeze

  # Modules Inclusion
  include AASM

  # Constants
  PAPERCLIP_IMAGE_CONTENT_TYPE = [/\Aimage\/.*\z/, "application/json"]

  # Associations
  belongs_to :attachable, polymorphic: true
  has_attached_file :data

  # Validations
  validates_attachment_presence :data
  validates_attachment :data, content_type: { content_type: PAPERCLIP_IMAGE_CONTENT_TYPE }

  # Callbacks
  after_update :update_bol_file_status, if: proc { previous_changes.has_key?(:status) }

  enum status: {
    uploaded: 0,
    ocr_pending: 1,
    ocr_done: 2,
    qa_approved: 3,
    qa_rejected: 4,
    uat_rejected: 5,
    released: 6
  }

  aasm column: 'status', enum: true, whiny_transitions: false do
    state :uploaded, initial: true
    state :ocr_pending, :ocr_done, :qa_approved, :qa_rejected

    event :sent_to_ocr do
      transitions from: :uploaded, to: :ocr_pending
    end

    event :parsed do
      transitions from: :ocr_pending, to: :ocr_done
    end

    event :qa_approve do
      transitions from: %i[ocr_done qa_rejected], to: :qa_approved
    end

    event :qa_reject do
      transitions from: %i[ocr_done qa_approved], to: :qa_rejected
    end

    event :uat_reject do
      transitions from: :qa_approved, to: :uat_rejected
    end

    event :release do
      transitions from: :qa_approved, to: :released
    end
  end

  def path
    data.path
  end

  def update_bol_file_status
    bol_status = []
    attachable.attachments.pluck(:status).each { |status| bol_status << Attachment.statuses[status]}
    attachable.method((Attachment.statuses.key(bol_status.min) + '!').to_sym).call
  end
end