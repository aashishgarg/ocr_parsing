module Ocr

  class ProcessImage

    def initialize
      @uri = URI.parse(ENV["ocr_url"])
    end

    def fetch_s3_image(remote_file_url)
      header = {"Content-type": "application/json"}
      response = open(remote_file_url) {|f| f.read }
      base64_encoded_image = Base64.encode64(response)
      http = Net::HTTP.new(@uri.host, @uri.port)
      request = Net::HTTP::Post.new(@uri.request_uri, header)
      request.body = base64_encoded_image
      response = http.request(request)
    end

  end

end