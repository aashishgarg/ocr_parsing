module Statuses
  extend ActiveSupport::Concern

  included do
    enum status: {
      uploaded: 0,
      ocr_pending: 1,
      ocr_done: 2,
      qa_approved: 3,
      qa_rejected: 4,
      uat_rejected: 5,
      released: 6
    }
  end
end