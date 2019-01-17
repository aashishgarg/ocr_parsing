module Ocr
  class ProcessFiles < Base
    attr_accessor :bol_file, :response_required_fields, :local_file, :uri, :current_attachment, :http, :request,
                  :response, :processed_data
    extend ActiveModel::Callbacks
    define_model_callbacks :process_s3_file, :push_to_ocr

    # Callbacks
    after_process_s3_file :push_to_ocr
    before_push_to_ocr :set_request
    before_push_to_ocr :set_status
    after_push_to_ocr :set_status
    after_push_to_ocr :process_ocr_data

    def initialize(bol_file)
      @bol_file = bol_file
      @response_required_fields = Attachment::REQUIRED_FIELDS
      @local_file = nil
      @uri = URI.parse(ENV['OCR_SERVICE_URL'])
      @current_attachment = nil
      @http = Net::HTTP.new(@uri.host, @uri.port)
      @request = Net::HTTP::Post.new(@uri.request_uri, { 'Content-Type': 'application/json' })
      @response = nil
      @processed_data = nil
    end

    def process_s3_file
      run_callbacks :process_s3_file do
        @bol_file.attachments.each do |attachment|
          @current_attachment = attachment
          @local_file = S3::ProcessFiles.new(attachment).download_s3_file.body.path
        end
      end
    end

    def push_to_ocr
      run_callbacks :push_to_ocr do
        @response = http.request(request)
      end
    end

    private

    def set_request
      @request.body = { data: Base64.encode64(File.read(@local_file)).delete('\n') }.to_json
    end

    def set_status
      if @response.nil?
        @current_attachment.sent_to_ocr!
      elsif @response.code.eql? '200'
        @current_attachment.ocr_done!
      end
    end

    def process_ocr_data
      @processed_data = Ocr::Parser.new(JSON.parse(@response.body)['data'], @response_required_fields).add_status_keys.to_json
      @current_attachment.update(ocr_parsed_data: @response.body, processed_data: @processed_data)
    end
  end
end
