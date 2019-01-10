module S3
  class ProcessFiles < Base
    def initialize(file)
      @file = file
      @key = file.path.sub('/', '')
    end

    def process_s3_request
      file_urls = bol_file.get_attachment_urls
      @urls.each {|url| download_s3_file(url)}
    end

    def download_s3_file
      directory_name = "#{Rails.root}/public/bol_files"
      Dir.mkdir(directory_name) unless Dir.exists?(directory_name)
      download(directory_name, @key)
    end
  end
end