module S3
  class Base
    def resource
      Aws::S3::Resource.new(
          region: 'us-east-1',
          access_key_id: ENV['AWS_ACCESS_KEY_ID'],
          secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'])
    end

    def client
      resource.client
    end

    def objects
      resource.bucket("#{ENV['AWS_BUCKET']}").objects
    end

    def download(path, key)
      File.open(path + '/' + File.basename(key), 'wb') do |file|
        client.get_object({bucket: ENV['AWS_BUCKET'], key: key}, target: file)
      end
    end
  end
end