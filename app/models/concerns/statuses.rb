module Statuses
  extend ActiveSupport::Concern

  included do
    enum status: {
      uploaded: 0,
      ocr_pending: 1,
      failed_at_ocr: 2,
      ocr_done: 3,
      qa_approved: 4,
      qa_rejected: 5,
      uat_rejected: 6,
      released: 7
    }
  end
end