s3_credentials = {
  access_key_id: Conf.aws_access_key,
  secret_access_key: Conf.aws_access_secret,
  bucket: Conf.default_s3_bucket
}

Paperclip::Attachment.default_options[:storage] = :s3
Paperclip::Attachment.default_options[:s3_protocol] = 'https'
Paperclip::Attachment.default_options[:s3_region] = 'us-west-1'
Paperclip::Attachment.default_options[:s3_host_name] = 's3-us-west-1.amazonaws.com'
Paperclip::Attachment.default_options[:s3_permissions] = "public-read"
Paperclip::Attachment.default_options[:s3_credentials] = s3_credentials

Paperclip.options[:content_type_mappings] = {
  csv: ["text/csv", "application/vnd.ms-excel"]
}

module Paperclip
  def self.convert_options_from_crop_actions(crop_actions)
    return "" unless crop_actions && !crop_actions.empty?

    crop_actions = crop_actions.deep_symbolize_keys

    crop = crop_actions[:crop].inject({}) { |m,(k,v)| m.update(k => v.to_i) }
    size = crop_actions[:size]

    options =  []
    options << "-crop %{width}x%{height}+%{x}+%{y}" % crop if crop
    options << "-resize %{width}x%{height}" % size if size

    options.join(' ')
  end
end