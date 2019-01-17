module Ocr
  class ProcessFiles < Base
    def initialize(bol_file)
      @bol_file = bol_file
      @local_file = nil
      @uri = URI.parse(ENV['OCR_SERVICE_URL'])
      @current_attachment = nil
    end

    def process_s3_file
      @bol_file.attachments.each do |attachment|
        @current_attachment = attachment
        @local_file = S3::ProcessFiles.new(attachment).download_s3_file.body.path
        send_to_ocr(@local_file)
      end
    end

    def send_to_ocr(file_path)
      headers = { 'Content-Type': 'application/json' }
      http = Net::HTTP.new(@uri.host, @uri.port)
      request = Net::HTTP::Post.new(@uri.request_uri, headers)
      request.body = { data: Base64.encode64(File.read(file_path)).delete('\n') }.to_json
      @current_attachment.sent_to_ocr!
      response = http.request(request)
      @current_attachment.ocr_done! if response.code.eql? '200'
      processed_data = Ocr::Parser.new(JSON.parse(response.body)['data'], Attachment::REQUIRED_FIELDS).add_status_keys.to_json
      @current_attachment.update(ocr_parsed_data: response.body, processed_data: processed_data)
    end
  end
end
