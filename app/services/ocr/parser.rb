module Ocr
  class Parser < Base
    def initialize(json_data, required_keys)
      @json_data = json_data
      @required_keys = required_keys
      add_required_keys if required_keys.present?
    end

    def add_required_keys
      (@required_keys - @json_data.keys).each { |key| @json_data[key] = nil }
    end

    def add_status_keys
      @json_data.each do |key, value|
        @json_data[key] = { value: value, status: nil }
      end
      @json_data
    end
  end
end