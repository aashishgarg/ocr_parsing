module Ocr
  class ProcessFiles < Base
    def initialize(bol_file)
      @bol_file = bol_file
      @local_files = []
      @uri = URI.parse(ENV['OCR_URL'])
    end

    def process_s3_file
      @bol_file.attachments.each do |attachment|
        @local_files << S3::ProcessFiles.new(attachment).download_s3_file.body.path
      end
      convert_files
    end

    def convert_files
      @local_files.each do |path|
        new_file_path = "#{File.dirname(path)}/#{File.basename(path, File.extname(path))}.#{BolFile::BOL_EXT}"
        if system("convert #{path} #{new_file_path}")
          PushFilesToOcrJob.perform_later(@bol_file, new_file_path) if File.exist?(new_file_path)
        end unless (File.extname(path) == BolFile::BOL_EXT)
      end
    end

    def push_file(file_path)
      header = {"Content-type": "application/json"}
      response = open(file_path) {|f| f.read }
      base64_encoded_image = Base64.encode64(response)
      http = Net::HTTP.new(@uri.host, @uri.port)
      request = Net::HTTP::Post.new(@uri.request_uri, header)
      request.body = base64_encoded_image
      response = http.request(request)
      puts response.inspect
    end
  end
end