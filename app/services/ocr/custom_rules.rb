module Ocr
  class CustomRules < Base
    attr_accessor :json_data

    def initialize(json_data)
      @json_data = json_data
    end

    def apply_all
      apply_bol_number
      apply_payment_terms
    end

    def apply_bol_number
      json_data['BolNumber'] = %w[BolNumber bolNumber BOLNumber].collect { |key| json_data.delete(key) }.compact.first
      json_data
    end

    def apply_payment_terms
      permitted_payment_term = (json_data['PaymentTerms']&.strip!).in?(Attachment::PAYMENT_TERMS.keys)
      json_data['PaymentTerms'] = Attachment::PAYMENT_TERMS.key('Prepaid') unless permitted_payment_term
      json_data
    end
  end
end