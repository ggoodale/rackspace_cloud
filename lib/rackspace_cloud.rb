require "patron"
require "json"
require "uri"
require "digest/sha1"
require "base64"

# Bring in all of our submodules
Dir[File.join(File.dirname(__FILE__), 'rackspace_cloud/**/*.rb')].sort.each { |lib| require lib }

module RackspaceCloud
  
  class ConfigurationError < StandardError; end
  class AuthorizationError < StandardError; end
  
  API_VERSION = "1.0"
  BASE_AUTH_URI = "https://auth.api.rackspacecloud.com"
        
  def RackspaceCloud.auth_url
    @@auth_uri ||= URI.parse("#{BASE_AUTH_URI}/v#{API_VERSION}")
  end
   
end