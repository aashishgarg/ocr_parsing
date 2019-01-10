class Attachment < ApplicationRecord
  # Constants
  PAPERCLIP_IMAGE_CONTENT_TYPE = ["image/jpg", "image/jpeg", "image/png", "application/json"]

  # Associations
  belongs_to :attachable, polymorphic: true
  has_attached_file :data

  # Validations
  validates_attachment_presence :data
  validates_attachment :data, content_type: { content_type: PAPERCLIP_IMAGE_CONTENT_TYPE }
end
