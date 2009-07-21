module RackspaceCloud
  class Server
    attr_reader :name, :status, :flavor_id, :image
    attr_reader :rackspace_id, :host_id, :progress
    attr_reader :public_ips, :private_ips, :adminPass

    STATUS_VALUES = %w{ACTIVE BUILD REBUILD SUSPENDED QUEUE_RESIZE PREP_RESIZE VERIFY_RESIZE PASSWORD RESCUE REBOOT HARD_REBOOT SHARE_IP SHARE_IP_NO_CONFIG DELETE_IP UNKNOWN}

    def initialize(server_json)
      populate(server_json)
    end
    
    def reboot
      RackspaceCloud.request("/servers/#{@rackspace_id}/action", :method => :post, :data => {'reboot' => {'type' => 'SOFT'}})
    end
    
    def hard_reboot
      RackspaceCloud.request("/servers/#{@rackspace_id}/action", :method => :post, :data => {'reboot' => {'type' => 'HARD'}})      
    end
    
    def suspend
      
    end
    
    def resume
    end

    # update this server's status and progress by calling /servers/<id>
    def refresh
      populate(RackspaceCloud.request("/servers/#{@rackspace_id}")['server'])
      self
    end
    
    protected
    
    def populate(server_json)
      @name = server_json['name']
      @status = server_json['status']
      @flavor = RackspaceCloud::Flavor.lookup_by_id(server_json['flavorId'])
      @image = RackspaceCloud::Image.lookup_by_id(server_json['imageId'])
      @rackspace_id = server_json['id']
      @host_id = server_json['hostId']
      @progress = server_json['progress']
      @public_ips = server_json['addresses']['public']
      @private_ips = server_json['addresses']['private']
      @adminPass = server_json['adminPass']
    end
  end
end