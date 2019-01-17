class BolFile < ApplicationRecord
  # Modules Inclusions
  include Attachable
  include Statuses

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

  def self.search(params)
    filter(params[:filter_column], params[:filter_value]).ordering(params[:order_column], params[:order]).page(params[:page]).per(params[:per_page])
  end

  def self.filter(names, values = [])
    return all if names.blank?
    names_array = (names.is_a?(Array) ? names[0]&.split(',') : false)
    if names_array.present? && values.present?
      condition = ''
      value_array = []
      values = values[0].split(',')
      names_array.each_with_index do |name, index|
        value_array << (name == 'status' ? statuses[values[index]] : values[index])
        condition << " #{name} = ? and"
      end
      (names_array.size == values.size) ? where(condition.chomp!('and'), *value_array) : all
    else
      all
    end
  end

  def self.ordering(name, value = nil)
    name.present? ? order(name => value) : order(created_at: :desc)
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