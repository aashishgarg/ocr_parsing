module QueryBuilder
  extend ActiveSupport::Concern

  module ClassMethods
    # Prepare the (where) part of the query
    def filter(names = [], values = [])
      return all if names.nil? || names.empty?
      raise FilterColumnOrValuesNotArray if !names.is_a?(Array) || !values.is_a?(Array)
      raise FilterColumnAndValuesNotSame unless names.separated.size == values.separated.size
      raise ColumnNotValid unless valid_columns?(names.separated)

      filter_string = ''
      names.separated.zip(values.separated).each do |key_value|
        value = key_value[0] == 'status' ? (BolFile.statuses[key_value[1]] || -1) : key_value[1]
        filter_string << " #{key_value[0]} = '#{value}' and"
      end
      where(filter_string.chomp!('and'))
    end

    # Prepare the (order) part of the query
    def ordering(name, value)
      raise ColumnNotValid if !name.nil? && !valid_columns?([name])
      return order(name => BolFile.statuses[value]) if name == 'status'

      order(name.present? ? { name => (value || 'asc') } : { created_at: :desc })
    end

    # validates if the columns user exists in the table or not
    def valid_columns?(names)
      names - columns.collect(&:name) == []
    end

    # Combines all (where and order) parts of sql query and retrieves records
    def search(params)
      filter(params[:filter_column], params[:filter_value])
        .ordering(params[:order_column], params[:order])
        .page(params[:page])
        .per(params[:per])
    end

    def counts
      status_hash = BolFile.all.group_by(&:status).with_indifferent_access
      {
        qa_approved: status_hash[:qa_approved]&.count || 0,
        qa_rejected: status_hash[:qa_rejected]&.count || 0,
        ocr_done: status_hash[:ocr_done]&.count || 0,
        qa_approved: status_hash[:qa_approved]&.count || 0,
        released: status_hash[:released]&.count || 0
      }
    end

    def page_details(params)
      {
        total_records: count,
        total_pages: search(params).total_pages,
        current_page: search(params).current_page
      }
    end

    # Data required for the dashboard
    def data_hash(params)
      hash = { bol_files: search(params).as_json(include: :attachments) }
      hash[:counts] = counts if params[:dashboard] == 'true'
      hash[:page_details] = page_details(params)
      hash
    end
  end

  included do
    extend ClassMethods
  end
end