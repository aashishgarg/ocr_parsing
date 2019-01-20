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
end
