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

  # storage for the lists of flavors and images we request at auth time
  FLAVORS = {}
  def RackspaceCloud.populate_flavors
    request("/flavors/detail")['flavors'].each do |flavor|
      FLAVORS[flavor['id']] = RackspaceCloud::Flavor.new(flavor)
    end
    nil
  end
  
  IMAGES = {}
  def RackspaceCloud.populate_images
    request("/images/detail")['images'].each do |image|
      IMAGES[image['id']] = RackspaceCloud::Image.new(image)
    end
    nil
  end
  
  LIMITS = {}
  def RackspaceCloud.get_limits
    LIMITS.merge!(request("/limits")['limits'])
    nil
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
      @server_management_url = response.headers['X-Server-Management-Url']
      @storage_url = response.headers['X-Storage-Url']
      @storage_token = response.headers['X-Storage-Token']
      @cdn_management_url = response.headers['X-CDN-Management-Url'] 
      @auth_token = response.headers['X-Auth-Token']
      @@authorized = true
    else 
      raise AuthorizationError, "Error during authorization: #{response.status}"
    end
    nil
  end

  def RackspaceCloud.request(path, options={})
    raise RuntimeError, "Please authorize before using by calling connect()" unless defined?(@@authorized) && @@authorized
    @session ||= begin
      s = Patron::Session.new
      s.base_url = @server_management_url
      s.headers['X-Auth-Token'] = @auth_token
      s.headers["User-Agent"] = "rackspacecloud_ruby_gem"
      s.timeout = 10
      s
    end
    response = case options[:method]
    when :post
      @session.headers['Accept'] = "application/json"
      @session.headers['Content-Type'] = "application/json"
      @session.post("#{path}", options[:data].to_json)
    when :put
      @session.headers['Content-Type'] = "application/json"
      @session.put("#{path}", options[:data].to_json)      
    when :delete
      @session.delete("#{path}")
    else      
      @session.get("#{path}.json")
    end

    case response.status
    when 200, 202, 204
      JSON.parse(response.body) unless response.body.empty?
    else
      puts response.body
      raise RuntimeError, "Error fetching #{path}: #{response.status}"
    end
  end
end