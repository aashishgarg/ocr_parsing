class BolFile < ApplicationRecord
  # Constants
  BOL_EXT = 'png'.freeze

  # Modules Inclusions
  include Attachable

  # Associations
  belongs_to :user, foreign_key: :status_updated_by
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

  # States: uploaded pending_parsing done_parsing qa_rejected qa_approved
  #         uat_rejected uat_approved released
  state_machine :state, initial: :uploaded do
    event :sent_to_ocr do
      transition uploaded: :pending_parsing
    end

    event :parsed do
      transition pending_parsing: :done_parsing
    end

    event :qa_approved do
      transition %i[done_parsing qa_rejected] => :qa_approved
    end

    event :qa_rejected do
      transition done_parsing: :qa_rejected
    end

    event :uat_approved do
      transition %i[done_parsing qa_approved] => :done_parsing
    end

    event :uat_rejected do
      transition %i[done_parsing qa_approved] => :done_parsing
    end
  end

  after_create_commit :queue_files, if: proc { attachments.exists? }

  def attachment_urls
    attachments.collect(&:url)
  end

  def self.get_filtered_data(params)
    order = params[:order].present? ? params[:order] : 'desc'
    if params[:filter_column].present? && params[:order_column].present?
      where("#{params['filter_column']} = ?", params[:filter_value]).order("#{params['order_column']} #{order}").page(params[:page])
    elsif params[:filter_column].present? && params[:order_column].blank?
      where("#{params['filter_column']} = ?", params[:filter_value]).page(params[:page])
    elsif params[:filter_column].blank? && params[:order_column].present?
      order("#{params['order_column']} #{order}").page(params[:page])
    else
      if params[:order_column].present?
        order("#{params['order_column']} #{order}").page(params[:page])
      else
        page(params[:page])
      end
    end
  end

  private

  def queue_files
    ProcessFilesJob.perform_later(self)
  end
end