class BolFile < ApplicationRecord
  # Constants
  BOL_EXT = 'png'.freeze

  # Modules Inclusions
  include Attachable

  enum status: { uploaded: 0, pending_parsing: 1, done_parsing: 2, qa_rejected: 3, qa_approved: 4, uat_rejected: 5,
                 uat_approved: 5, released: 6 }

  # Associations
  belongs_to :user, foreign_key: :status_updated_by, inverse_of: :bol_files
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
    ProcessFilesJob.perform_later(self)
  end
end