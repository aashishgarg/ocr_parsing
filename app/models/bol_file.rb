class BolFile < ApplicationRecord
  BOL_EXT = 'png'.freeze

  include Attachable

  belongs_to :user, foreign_key: :status_updated_by
  belongs_to :shipper
  belongs_to :bol_type

  accepts_nested_attributes_for :attachments

  validates :status, presence: true
  # ToDo: Add file size validation

  # States: uploaded pending_parsing done_parsing qa_rejected qa_approved
  #         uat_rejected uat_approved released
  state_machine :state, initial: :uploaded do
    event :sent_to_ocr do
      transition uploaded: :pending_parsing
    end

    event :parsed do
      transition pending_parsing: :done_parsing
    end

    event :qa_approved do
      transition %i[done_parsing qa_rejected] => :qa_approved
    end

    event :qa_rejected do
      transition done_parsing: :qa_rejected
    end

    event :uat_approved do
      transition %i[done_parsing qa_approved] => :done_parsing
    end

    event :uat_rejected do
      transition %i[done_parsing qa_approved] => :done_parsing
    end
  end

  before_validation do
    if status_changed? || new_record?
      self.status_updated_by = User.current.id
      self.status_updated_at = Time.now
    end
  end

  after_create_commit :queue_files, if: proc { attachments.exists? }

  def attachment_urls
    attachments.collect(&:url)
  end

  private

  def queue_files
    ProcessFilesJob.perform_later(self)
  end
end