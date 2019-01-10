module S3
  class ProcessFiles < Base
    def initialize(file)
      @file = file
      @key = file.path.sub('/', '')
    end

    def process_s3_request
      file_urls = bol_file.get_attachment_urls
      @urls.each {|url| download_s3_file(url)}

      # header = {"Content-type": "application/json"}
      # response = open(bol_file_object) {|f| f.read }
      # base64_encoded_image = Base64.encode64(response)
      # http = Net::HTTP.new(@uri.host, @uri.port)
      # request = Net::HTTP::Post.new(@uri.request_uri, header)
      # request.body = base64_encoded_image
      # response = http.request(request)
    end

    def download_s3_file
      directory_name = "#{Rails.root}/public/bol_files/original"
      Dir.mkdir(directory_name) unless Dir.exists?(directory_name)
      download(directory_name, @key)
    end
  end
end