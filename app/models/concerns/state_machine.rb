module StateMachine
  extend ActiveSupport::Concern

  included do
    # Modules Inclusions
    include AASM
    include Statuses

    aasm column: 'status', enum: true, whiny_transitions: false do
      state :uploaded, initial: true
      state :ocr_pending, :ocr_done, :qa_approved, :qa_rejected, :uat_rejected, :released

      event :sent_to_ocr do
        transitions from: :uploaded, to: :ocr_pending
      end

      event :parsed, after: :update_bol_extracted do
        transitions to: :ocr_done
      end

      event :qa_approve do
        transitions from: %i[ocr_done qa_rejected], to: :qa_approved
      end

      event :qa_reject do
        transitions from: %i[ocr_done qa_approved], to: :qa_rejected
      end

      event :uat_reject do
        transitions from: :qa_approved, to: :uat_rejected
      end

      event :release do
        transitions from: :qa_approved, to: :released
      end
    end
  end
end