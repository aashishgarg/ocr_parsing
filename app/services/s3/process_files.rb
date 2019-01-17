module S3
  class ProcessFiles < Base
    extend ActiveModel::Callbacks
    define_model_callbacks :download_s3_file

    # Callbacks
    before_download_s3_file :provision_directory

    def initialize(file)
      @directory = "#{Rails.root}/public/bol_files"
      @key = (file.data_content_type.eql?('image/png') ? file.data.path : file.data.path(:processed)).sub('/', '')
    end

    def download_s3_file
      run_callbacks :download_s3_file do
        download(@directory, @key)
      end
    end

    private

    def provision_directory
      Dir.mkdir(@directory) unless Dir.exists?(@directory)
    end
  end
end
