module CustomRule
  extend ActiveSupport::Concern

  included do
    extend ClassMethods
    #Constants
    PAYMENT_TERMS = {
      'PPD' => 'Prepaid',
      'COL' => 'Collect',
      '3RD' => 'Third party'
    }.freeze
  end

  module ClassMethods
    def parse_custom_rules(json_data)
      process_payment_terms(json_data)
      json_data['BolNumber'] = %w[BolNumber bolNumber BOLNumber].collect { |key| json_data.delete(key) }.compact.first
      json_data
    end

    def process_payment_terms(json_data)
      if json_data['PaymentTerms'].present?
        json_data['PaymentTerms'] = 'PPD' unless PAYMENT_TERMS.keys.include?(json_data['PaymentTerms'].strip!)
      else
        json_data['PaymentTerms'] = 'PPD'
      end
    end
  end
end
