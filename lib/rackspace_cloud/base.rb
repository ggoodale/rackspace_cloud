module RackspaceCloud
  class Base
    attr_reader :user, :access_key, :auth_token

    def initialize(config={})
      validate_config(config)
      @user = config[:user]
      @access_key = config[:access_key]
    end

    def authorize
      request_authorization
    end

    def servers
      JSON.parse(request("/servers.json"))["servers"]
    end

    protected

    def validate_config(config)
      errors = []
      (config[:user] && config[:user].length) || errors << "missing username"
      (config[:access_key] && config[:access_key].length) || errors << "missing access_key"
      raise(ArgumentError, "Error: invalid configuration: #{errors.join(';')}") unless errors.empty?
    end

    def request_authorization
      session = Patron::Session.new
      session.base_url = RackspaceCloud::BASE_AUTH_URI
      session.headers["X-Auth-User"] = @user
      session.headers["X-Auth-Key"] = @access_key
      session.headers["User-Agent"] = "rackspacecloud_ruby_gem"
      response = session.get("/v#{RackspaceCloud::API_VERSION}")
      
      case response.status
      when 204 # "No Content", which means success
        @server_management_url = response.headers['X-Server-Management-Url']
        @storage_url = response.headers['X-Storage-Url']
        @storage_token = response.headers['X-Storage-Token']
        @cdn_management_url = response.headers['X-CDN-Management-Url'] 
        @auth_token = response.headers['X-Auth-Token']
      else 
        raise AuthorizationError, "Error during authorization: #{curl.response_code}"
      end
      nil
    end
    
    def request(path)
      session = Patron::Session.new
      session.base_url = @server_management_url
      session.headers['X-Auth-Token'] = @auth_token
      response = session.get(path)
      case response.status
      when 200
        response.body
      else
        raise RuntimeError, "Error fetching #{path}: #{response.status}"
      end
    end
  end
end