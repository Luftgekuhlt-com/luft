module Amazon
  module S3
    def s3_bucket
      s3_resource.bucket(s3_bucket_name)
    end

    def s3_resource
      @s3_resource ||= Aws::S3::Resource.new(s3_config)
    end

    def s3_config
      {
        region: "us-west-1",
        access_key_id: Conf.aws_access_key,
        secret_access_key: Conf.aws_access_secret
      }
    end

    def s3_bucket_name
      Conf.default_s3_bucket
    end

    def s3_upload(destination, data, options = {})
      s3     = Aws::S3::Client.new(s3_config)
      bucket = options[:bucket].presence || s3_bucket_name
      acl    = options[:acl].presence || "public-read"

      put_options = { bucket: bucket, key: destination, body: data, acl: acl }
      put_options[:content_type] = options[:content_type] if options[:content_type].present?

      begin
        s3.put_object(put_options)
      rescue Exception => e
        puts e.message
        puts e.backtrace
      end
    end

    def s3_url_for(path, root=nil)
      [root || s3_root, path].join('/')
    end

    def s3_root
      "https://s3.amazonaws.com/#{s3_bucket_name}"
    end

    private

    def establish_connection!
      AWS::S3::Base.establish_connection!(
        access_key_id: s3_config[:access_key_id],
        secret_access_key: s3_config[:secret_access_key]
      ) unless connection_established?

      @connection = true
    end

    def connection_established?
      @connection
    end
  end
end
