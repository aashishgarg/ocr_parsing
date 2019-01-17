module S3
  class ProcessFiles < Base
    def initialize(file)
      @file = file
      @key = file.data.path.sub('/', '')
      @key = file.data.path(:processed).sub('/', '') unless file.data_content_type.eql?('image/png')
    end

    def download_s3_file
      directory_name = "#{Rails.root}/public/bol_files"
      Dir.mkdir(directory_name) unless Dir.exists?(directory_name)
      download(directory_name, @key)
    end
  end
end
