module RackspaceCloud
  class Base
    attr_reader :user, :access_key, :auth_token

    def initialize(config={})
      validate_config(config)
      @user = config[:user]
      @access_key = config[:access_key]
    end

    def connect
      RackspaceCloud.request_authorization(@user, @access_key)
      RackspaceCloud.populate_flavors
      RackspaceCloud.populate_images
    end

    def servers
      RackspaceCloud.request("/servers/detail")["servers"].collect {|server_json|
        RackspaceCloud::Server.new(server_json)
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
      
      RackspaceCloud::Server.new(RackspaceCloud.request("/servers", :method => :post, :data => new_server_data))
    end

    protected

    def validate_config(config)
      errors = []
      (config[:user] && config[:user].length) || errors << "missing username"
      (config[:access_key] && config[:access_key].length) || errors << "missing access_key"
      raise(ArgumentError, "Error: invalid configuration: #{errors.join(';')}") unless errors.empty?
    end
  end
end