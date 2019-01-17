module S3
  class ProcessFiles < Base
    extend ActiveModel::Callbacks
    define_model_callbacks :download_s3_file
    attr_accessor :directory, :key, :s3_local_object, :file_path

    # Callbacks
    before_download_s3_file :provision_directory
    after_download_s3_file :set_path

    def initialize(file)
      @directory = "#{Rails.root}/public/bol_files"
      @key = (file.data_content_type.eql?('image/png') ? file.data.path : file.data.path(:processed)).sub('/', '')
      @s3_local_object = nil
      @file_path = nil
    end

    def download_s3_file
      run_callbacks :download_s3_file do
        @s3_local_object = download(@directory, @key)
      end
    end

    def clean_local_file
      File.delete(@file_path) if File.exist? @file_path
    end

    private

    def set_path
      @file_path = @s3_local_object.body.path
    end

    def provision_directory
      Dir.mkdir(@directory) unless Dir.exists?(@directory)
    end
  end
end
