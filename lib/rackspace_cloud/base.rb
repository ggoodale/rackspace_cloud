module RackspaceCloud
  class Base
    attr_reader :user, :access_key, :auth_token, :session

    def initialize(config={})
      validate_config(config)
      @user = config[:user]
      @access_key = config[:access_key]
      @authorized = false
    end

    def connect
      configure_services(RackspaceCloud.request_authorization(@user, @access_key))
      RackspaceCloud.check_version_compatibility
      @authorized = true
      populate_flavors
      populate_images
      get_limits
    end
    
    def authorized?
      @authorized
    end

    # storage for the lists of flavors and images we request at auth time
    attr_reader :flavors
    def populate_flavors
      @flavors ||= {}
      request("/flavors/detail")['flavors'].each do |flavor|
        @flavors[flavor['id']] = RackspaceCloud::Flavor.new(flavor)
      end
      nil
    end

    attr_reader :images
    def populate_images
      @images ||= {}
      request("/images/detail")['images'].each do |image|
        @images[image['id']] = RackspaceCloud::Image.new(self, image)
      end
      nil
    end

    attr_reader :limits
    def get_limits
      @limits ||= {}
      @limits.merge!(request("/limits")['limits'])
      nil
    end
    
    def servers
      request("/servers/detail")["servers"].collect {|server_json|
        RackspaceCloud::Server.new(self, server_json)
      }
    end
    
    def create_server(name, flavor, image, metadata={}, personality=[])
      new_server_data = {'server' => {
        'name' => name,
        'flavorId' => flavor.to_i,
        'imageId'  => image.to_i,
        'metadata' => metadata,
        'personality' => personality
      }}
      
      RackspaceCloud::Server.new(self, request("/servers", :method => :post, :data => new_server_data)['server'])
    end
    
    def shared_ip_groups
      request("/shared_ip_groups/detail")['sharedIpGroups'].collect {|group_json|
        RackspaceCloud::SharedIPGroup.new(self, group_json)
      }
    end
    
    # Yes, you can only specify at most a single server to initially populate a shared IP group.  Odd, that.
    def create_shared_ip_group(name, server=nil)
      new_group_data = {'sharedIpGroup' => {'name' => name, 'server' => server}}
      new_group_data['sharedIpGroup']['server'] = server.to_i unless server.nil?
      RackspaceCloud::SharedIPGroup.new(self, request("/shared_ip_groups", :method => :post, :data => new_group_data))
    end

    def request(path, options={})
      raise RuntimeError, "Please authorize before using by calling connect()" unless authorized?
      response = case options[:method]
      when :post, :put
        session.headers.merge!('Accept' => "application/json", 'Content-Type' => "application/json")
        session.send(options[:method], "#{path}", options[:data].to_json)
      when :delete
        session.delete("#{path}")
      else      
        session.get("#{path}.json")
      end

      case response.status
      when (200..204)
        JSON.parse(response.body) unless response.body.empty?
      else
        raise RuntimeError, "Error fetching #{path}: #{response.status}"
      end
    end

    def api_version
      RackspaceCloud::API_VERSION
    end

    protected

    def validate_config(config)
      errors = [] 
      (config[:user] && config[:user].length) || errors << "missing username"
      (config[:access_key] && config[:access_key].length) || errors << "missing access_key"
      raise(ArgumentError, "Error: invalid configuration: #{errors.join(';')}") unless errors.empty?
    end
    
    def configure_services(url_hash = {})
      @server_management_url = url_hash['X-Server-Management-Url']
      @storage_url = url_hash['X-Storage-Url']
      @storage_token = url_hash['X-Storage-Token']
      @cdn_management_url = url_hash['X-CDN-Management-Url'] 
      @auth_token = url_hash['X-Auth-Token']
    end 
    
    def session
      @session ||= returning Patron::Session.new do |s|
        s.base_url = @server_management_url
        s.headers['X-Auth-Token'] = @auth_token
        s.headers["User-Agent"] = "rackspacecloud_ruby_gem"
        s.timeout = 10
      end
    end
  end
end