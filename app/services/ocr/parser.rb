module Ocr
  class Parser < Base
    def initialize(json_data, required_hash)
      @json_data = json_data
      @required_hash = required_hash
      add_required_keys if required_hash.present?
    end

    # Adds required keys to the json if not present
    def add_required_keys
      # @required_hash.merge(@json_data)
      (@required_hash - @json_data.keys).each { |key| @json_data[key] = nil }
    end

    # Modifies the Json and adds (value and status) keys in each key of json
    def add_status_keys
      @json_data.each do |key, value|
        @json_data[key] = { value: value, status: nil }
      end
      @json_data
    end
  end
end