module Statuses
  extend ActiveSupport::Concern

  included do
    enum status: {
      uploaded: 0,
      ocr_pending: 1,
      failed_at_ocr: 2,
      failed_in_response_parsing: 3,
      ocr_done: 4,
      qa_approved: 5,
      qa_rejected: 6,
      uat_rejected: 7,
      released: 8
    }
  end
end