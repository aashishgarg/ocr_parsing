module Ocr
  class CustomRules < Base
    attr_accessor :json_data

    def initialize(json_data)
      @json_data = json_data
    end

    def apply_all
      apply_payment_terms if json_data.key? 'PaymentTerms'
      apply_bol_number
    end

    def apply_bol_number
      json_data['BolNumber'] = %w[BolNumber bolNumber BOLNumber].collect { |key| json_data.delete(key) }.compact.first
      json_data
    end

    def apply_payment_terms
      Attachment::PAYMENT_TERMS.each_pair do |key, value|
        json_data['PaymentTerms'] = key if value['options'].include?(json_data['PaymentTerms'])
      end
      json_data
    end
  end
end
