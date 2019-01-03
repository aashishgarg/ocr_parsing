class Attachment < ApplicationRecord
  belongs_to :attachable, polymorphic: true

  has_attached_file :data

  validates_attachment_presence :data
  #  Add validation on content-type
  # validates_attachment_content_type :data, content_type: PAPERCLIP_IMAGE_CONTENT_TYPE
end
