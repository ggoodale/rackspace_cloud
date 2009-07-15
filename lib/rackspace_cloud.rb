class RackspaceCloud
  BASE_URI = "https://auth.api.rackspacecloud.com/v1.0"
  API_VERSION = "1.0"
    
  class << self
    
    def user
      raise "Error: no configuration set" unless @@config
      @@config[:user] || raise "Error: Username not set"
    end

    def auth_token
      raise "Error: no configuration set" unless @@config
      @@config[:auth_token] || raise "Error: Authorization Token not set"
    end
    
    def config 
      @@config
    end

    def config=(new_config)
      error = validate_config(new_config)
      raise "Error: invalid configuration: #{error}" unless error.nil?
      @@config = new_config 
    end
    
    protected 

    def validate_config(config)
      # TODO
      nil
    end
  end
end