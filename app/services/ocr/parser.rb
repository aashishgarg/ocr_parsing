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
    # ToDO: I look dirty and inefficient. Improve me
    def add_status_keys
      @final_hash.each do |key, value|
        if value.is_a?(Array)
          value.each do |val|
            val.each do |k, v|
              val[k] = { value: v, status: nil }
            end
          end
        else
          @final_hash[key] = { value: value, status: nil }
        end
      end

      @final_hash
    end
  end
end
