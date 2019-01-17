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

  def attachment_urls
    attachments.collect(&:url)
  end

  def self.counts
    all = BolFile.all
    status_hash = all.group_by(&:status).with_indifferent_access
    {
      total: count,
      file_verified: status_hash[:ocr_done]&.count || 0,
      ocr_done: status_hash[:ocr_done]&.count || 0,
      waiting_for_approval: status_hash[:qa_approved]&.count || 0,
      file_approved: status_hash[:released]&.count || 0
    }
  end
end