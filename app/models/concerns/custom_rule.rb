module CustomRule
  extend ActiveSupport::Concern

  included do
    extend ClassMethods
    # Constants
    PAYMENT_TERMS = {
      'PPD' => 'Prepaid',
      'COL' => 'Collect',
      '3RD' => 'Third Party'
    }.freeze
  end

  module ClassMethods
    def parse_custom_rules(json_data)
      process_payment_terms(json_data)
      bol_number = %w[BolNumber bolNumber BOLNumber].collect do |key|
        json_data.delete(key)
      end
      json_data['BolNumber'] = bol_number.compact.first
      json_data
    end

    def process_payment_terms(json_data)
      unless PAYMENT_TERMS.keys.include?(json_data['PaymentTerms']&.strip!)
        json_data['PaymentTerms'] = PAYMENT_TERMS.key('Prepaid')
      end
    end
  end
end
