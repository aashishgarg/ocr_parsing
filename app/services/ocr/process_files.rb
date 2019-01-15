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
        convert_file
      end
    end

    def convert_file
      new_file_path = "#{File.dirname(@local_file)}/#{File.basename(@local_file, File.extname(@local_file))}.#{BolFile::BOL_EXT}"
      unless File.extname(@local_file) == BolFile::BOL_EXT
        if system("convert #{@local_file} #{new_file_path}")
          send_to_ocr(new_file_path) if File.exist?(new_file_path)
        end
      end
    end

    def send_to_ocr(file_path)
      headers = { 'Content-Type': 'application/json' }
      http = Net::HTTP.new(@uri.host, @uri.port)
      request = Net::HTTP::Post.new(@uri.request_uri, headers)
      request.body = { data: Base64.encode64(File.read(file_path)).delete('\n') }.to_json
      @current_attachment.sent_to_ocr!
      response = http.request(request)
      response_body = response.body
      @current_attachment.ocr_done! if response.code.eql? '200'
      @current_attachment.update(ocr_parsed_data: response_body)#,
                                 # processed_data: Ocr::Parser.new(JSON.parse(response_body),
                                 #                                 Attachment::REQUIRED_FIELDS).add_status_keys.to_json)
    end
  end
end