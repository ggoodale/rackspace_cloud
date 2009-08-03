module RackspaceCloud
  class Server
    attr_reader :name, :status, :flavor, :image, :base
    attr_reader :rackspace_id, :host_id, :progress
    attr_reader :public_ips, :private_ips, :adminPass

    STATUS_VALUES = %w{ACTIVE BUILD REBUILD SUSPENDED QUEUE_RESIZE PREP_RESIZE VERIFY_RESIZE PASSWORD RESCUE REBOOT HARD_REBOOT SHARE_IP SHARE_IP_NO_CONFIG DELETE_IP UNKNOWN}

    def initialize(base, server_json)
      @base = base
      populate(server_json)
    end
    
    def ready?
      self.refresh.status == 'ACTIVE'
    end
    
    def reboot
      action_request('reboot' => {'type' => 'SOFT'})
    end
    
    def hard_reboot
      action_request('reboot' => {'type' => 'HARD'})      
    end
    
    def rebuild(new_image=nil)
      action_request('rebuild' => {'imageId' => new_image ? new_image.to_i : image.to_i})      
    end

    def resize(new_flavor)
      action_request('resize' => {'flavorId' => new_flavor.to_i})
    end

    def confirm_resize
      action_request('confirmResize' => nil)
    end
    
    def revert_resize
      action_request('revertResize' => nil)
    end

    def share_ip_address(ip_address, shared_ip_address_group, configure_server = true)
      @base.request("/servers/#{@rackspace_id}/ips/public/#{ip_address}", 
      :method => :put, :data => {'shareIp' => {'sharedIpGroupId' => shared_ip_address_group.to_i, 'configureServer' => configure_server}})
    end

    def unshare_ip_address(ip_address)
      @base.request("/servers/#{@rackspace_id}/ips/public/#{ip_address}", :method => :delete)
    end

    def delete
      @base.request("/servers/#{@rackspace_id}", :method => :delete)
    end

    def update_server_name(new_name)
      @base.request("/servers/#{@rackspace_id}", :method => :put, :data => {"server" => {"name" => new_name}})
    end

    def update_admin_password(new_password)
      @base.request("/servers/#{@rackspace_id}", :method => :put, :data => {"server" => {"adminPass" => new_password}})
    end

    # update this server's status and progress by calling /servers/<id>
    def refresh
      populate(@base.request("/servers/#{@rackspace_id}")['server'])
      self
    end
    
    protected
    
    def action_request(data)
      @base.request("/servers/#{@rackspace_id}/action", :method => :post, :data => data)      
    end
    
    def populate(server_json)
      @name = server_json['name']
      @status = server_json['status']
      @flavor = @base.flavors[server_json['flavorId']]
      @image = @base.images[server_json['imageId']]
      @rackspace_id = server_json['id']
      @host_id = server_json['hostId']
      @progress = server_json['progress']
      @public_ips = server_json['addresses']['public']
      @private_ips = server_json['addresses']['private']
      @adminPass = server_json['adminPass']
    end
  end
end