module RackspaceCloud
  class SharedIPGroup
    attr_reader :rackspace_id, :name, :servers

    def initialize(base, params)
      @base = base
      populate(params)
    end

    def delete
      @base.request("/shared_ip_groups/#{@rackspace_id}", :method => :delete)
    end

    def refresh
      populate(@base.request("/shared_ip_groups/detail")['sharedIpGroup'])
    end

    def to_i
      @rackspace_id
    end

    protected

    def populate(params)
      puts params.inspect
      @rackspace_id = params['id']
      @name = params['name']
      unless params['servers'].nil?
        @servers = @base.servers.select{|server| params['servers'].include? server.rackspace_id}
      end
    end
  end
end