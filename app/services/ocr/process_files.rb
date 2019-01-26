module Ocr
  class ProcessFiles < Base
    extend ActiveModel::Callbacks
    define_model_callbacks :download_file, :send_to_ocr

    # Attribute Accessors
    attr_accessor :attachment, :current_user, :response_required_fields, :local_file, :uri, :http, :request, :response,
                  :s3_file_processor, :update_hash, :json_parser

    # Callbacks
    before_send_to_ocr :download_file
    before_send_to_ocr :set_body
    before_send_to_ocr { attachment.sent_to_ocr! }
    after_send_to_ocr { response.code == '200' ? attachment.parsed! : attachment.failed! }
    after_send_to_ocr :dump_ocr_data
    after_send_to_ocr :process_ocr_data, if: proc { json_response['response_code'] == '100' }
    after_send_to_ocr :save_processed_data
    after_send_to_ocr :clean_references

    def initialize(attachment, current_user = nil)
      @attachment = attachment
      @attachment.processor = self
      @current_user = User.current = current_user
      @response_required_fields = Attachment::REQUIRED_HASH
      @local_file = nil
      @uri = URI.parse(ENV['OCR_SERVICE_URL'])
      @http = Net::HTTP.new(uri.host, uri.port)
      @http.use_ssl = true
      @request = Net::HTTP::Post.new(uri.request_uri, 'Content-Type': 'application/json')
      @response = nil
      @s3_file_processor = S3::ProcessFiles.new(attachment)
      @update_hash = {}
      @json_parser = nil
    end

    # Places request to OCR Service
    def send_to_ocr
      run_callbacks :send_to_ocr do
        self.response = http.request(request)
      end
    end

    # Downloads s3 object to local directory and extracts its local path
    def download_file
      run_callbacks :download_file do
        s3_file_processor.download_s3_file
        self.local_file = s3_file_processor.file_path
      end
    end

    private

    # Sets base64 of the image and send as binary
    def set_body
      request.body = Base64.strict_encode64(File.read(local_file))
    end

    # Updates the direct response in (ocr_parsed_data) and processed data in (processed_data) of Attachment
    def process_ocr_data
      self.json_parser = Ocr::Parser.new(json_response['data'], response_required_fields)
      json_parser.add_status_keys
    end

    def dump_ocr_data
      update_hash[:ocr_parsed_data] = json_response
    end

    def save_processed_data
      update_hash[:processed_data] = json_parser.final_hash
      attachment.update(update_hash)
    end

    def json_response
      JSON.parse(response.body)
    end

    # Deletes the local downloaded attachment file
    def clean_references
      s3_file_processor.clean_local_file if s3_file_processor.file_path
    end
  end
end
