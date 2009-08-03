require "patron"
require "json"
require "uri"
require "digest/sha1"
require "base64"

# Bring in all of our submodules
Dir[File.join(File.dirname(__FILE__), 'rackspace_cloud/**/*.rb')].sort.each { |lib| require lib }

module RackspaceCloud
  
  class APIVersionError    < StandardError; end
  class ConfigurationError < StandardError; end
  class AuthorizationError < StandardError; end
  
  API_VERSION = "1.0"
  BASE_AUTH_URI = "https://auth.api.rackspacecloud.com"
        
  def RackspaceCloud.auth_url
    @@auth_uri ||= URI.parse("#{BASE_AUTH_URI}/v#{API_VERSION}")
  end
   
  protected

  def RackspaceCloud.check_version_compatibility
    #This should eventually check the versions and raise an APIVersionError if there's a mismatch.
  end

  def RackspaceCloud.request_authorization(user, access_key)
    session = Patron::Session.new
    session.base_url = BASE_AUTH_URI
    session.headers["X-Auth-User"] = user
    session.headers["X-Auth-Key"] = access_key
    session.headers["User-Agent"] = "rackspacecloud_ruby_gem"
    response = session.get("/v#{API_VERSION}")
    
    case response.status
    when 204 # "No Content", which means success
      response.headers
    else 
      raise AuthorizationError, "Error during authorization: #{response.status}"
    end
  end
end