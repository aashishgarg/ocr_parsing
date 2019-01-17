module QueryBuilder
  extend ActiveSupport::Concern

  module ClassMethods
    def filter(names = [], values = [])
      raise FilterColumnOrValuesNotArray if !names.is_a?(Array) || !values.is_a?(Array)
      raise FilterColumnAndValuesNotSame unless names.separated.size == values.separated.size
      raise ColumnNotValid unless valid_columns?(names.separated)

      all if names.empty?
      filter_string = ''
      names.separated.zip(values.separated).each { |key_value| filter_string << " #{key_value[0]} = '#{key_value[1]}' and" }
      where(filter_string.chomp!('and'))
    end

    def ordering(name, value)
      raise ColumnNotValid unless valid_columns?([name])

      order(name.present? ? { name => (value || 'asc') } : { created_at: :desc })
    end

    def valid_columns?(names)
      names - columns.collect(&:name) == []
    end

    def search(params)
      filter(params[:filter_column], params[:filter_value]).ordering(params[:order_column], params[:order]).page(params[:page])
    end

    def dashboard_hash(params)
      data = search(params)
      status_hash = data.group_by(&:status).with_indifferent_access
      {
          data: data,
          counts: {
              total: count,
              file_verified: status_hash[:ocr_done]&.count || 0,
              ocr_done: status_hash[:ocr_done]&.count || 0,
              waiting_for_approval: status_hash[:qa_approved]&.count || 0,
              file_approved: status_hash[:released]&.count || 0
          }
      }
    end
  end

  included do
    extend ClassMethods
  end
end