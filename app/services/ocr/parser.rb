module Ocr
  class Parser < Base
    extend ActiveModel::Callbacks
    define_model_callbacks :add_status_keys

    # Attribute Accessors
    attr_accessor :json_data, :required_hash, :required_details, :final_hash, :merge_required

    # Callbacks
    before_add_status_keys :make_camelcase_keys
    before_add_status_keys :apply_custom_rules
    before_add_status_keys :set_data_in_details, if: proc { !json_data['Details'].present? }
    before_add_status_keys :add_required_keys

    def initialize(json_data, required_hash, merge_required = false)
      @json_data = json_data
      @required_hash = HashWithIndifferentAccess.new(required_hash.dup)
      @required_details = @required_hash.delete('Details')&.first
      @final_hash = {}
      @merge_required = merge_required
    end

    # Make all the keys in json camel cased
    def make_camelcase_keys
      json_data.mappable!
    end

    # Customizing the keys in the response json
    def apply_custom_rules
      self.json_data = Ocr::CustomRules.new(json_data).apply_all
    end

    # Checks for keys of [:Details] section - (Pieces, PackageType, Weight, Hazmat, Description, Class) at root of
    # coming json and adds then to :Details section.
    def set_data_in_details
      json_data.provision_details_hash!
    end

    # Adds required keys to the json if not present
    def add_required_keys
      required_hash.delete('Details') unless json_data['Details'].present?
      self.final_hash = merge_required ? required_hash.with_indifferent_access.merge(json_data) : json_data
    end

    # Modifies the Json and adds [:Value,:Status] keys in each key of json
    def add_status_keys
      run_callbacks :add_status_keys do
        details = final_hash.delete('Details') || []
        details.map! { |hash| hash.transform_values { |value| { Value: value, Status: nil } } }
        final_hash.transform_values! { |value| { Value: value, Status: nil } }['Details'] = details
        final_hash
      end
    end
  end
end
