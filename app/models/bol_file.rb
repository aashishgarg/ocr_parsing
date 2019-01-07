class BolFile < ApplicationRecord
  include Attachable

  enum status: { uploaded: 0, pending_parsing: 1, done_parsing: 2, qa_rejected: 3, qa_approved: 4, uat_rejected: 5,
                 uat_approved: 5, released: 6 }

  belongs_to :user, foreign_key: :status_updated_by
  belongs_to :shipper
  belongs_to :bol_type

  accepts_nested_attributes_for :attachments

  validates :status, presence: true
  # ToDo: Add file size validation

  before_validation do
    if status_changed? || new_record?
      self.status_updated_by = User.current.id
      self.status_updated_at = Time.now
    end
  end
end
