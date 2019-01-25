module Ocr
  class Parser < Base
    def initialize(json_data, required_hash)
      @json_data = json_data
      @required_hash = required_hash
      @final_hash = {}
      add_required_keys if required_hash.present?
    end

    # Adds required keys to the json if not present
    def add_required_keys
      @final_hash = @required_hash.with_indifferent_access.merge(@json_data)
    end

    # Modifies the Json and adds (value and status) keys in each key of json
    def add_status_keys
      details = @final_hash.delete(:Details)
      details.map! do |hash|
        hash.transform_keys!{ |key| key.delete(' ').camelcase }
        hash.transform_values { |value| { Value: value, Status: nil } }
      end
      @final_hash.transform_keys!{ |key| key.delete(' ').camelcase }
      @final_hash.transform_values! { |value| { Value: value, Status: nil } }.merge(Details: details)
    end
  end
end
