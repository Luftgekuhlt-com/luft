require 'faraday_middleware/aws_signers_v4'
# arguably this should be defined elsewhere
class AmazonElasticSearchClient
  def self.client
    return Elasticsearch::Client.new(url: Rails.application.secrets[:aws_es_endpoint]) do |f|
      f.request :aws_signers_v4,
                credentials: Aws::Credentials.new(Rails.application.secrets[:aws_access_key], Rails.application.secrets[:aws_access_secret]),
                service_name: 'es',
                region: 'us-west-1'
    end
  end
end

# for local development I run a local elasticsearch,
# so I only override the Searchkick.client in production environments
Searchkick.client = AmazonElasticSearchClient.client