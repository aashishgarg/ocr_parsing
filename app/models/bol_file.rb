class BolFile < ApplicationRecord
  # Modules Inclusions
  include Attachable
  include SidekiqMediator

  # Constants
  BOL_EXT = 'png'.freeze
  enum status: {
    uploaded: 0,
    ocr_pending: 1,
    ocr_done: 2,
    qa_approved: 3,
    qa_rejected: 4,
    uat_rejected: 5,
    released: 6
  }

  # Associations
  belongs_to :user, foreign_key: :status_updated_by
  accepts_nested_attributes_for :attachments

  # Validations
  validates :status, presence: true
  # TODO: Add file size validation

  # Callbacks
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
    perform_later(ProcessFilesJob, self)
  end
end