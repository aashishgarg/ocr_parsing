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
      details.map! { |hash| hash.transform_values { |value| { value: value, status: nil } } }
      @final_hash.transform_values! { |value| { value: value, status: nil } }.merge(Details: details)
    end
  end
end
