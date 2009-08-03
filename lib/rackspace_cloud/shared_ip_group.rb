module RackspaceCloud
  class SharedIPGroup
    attr_reader :rackspace_id, :name, :servers

    def initialize(base, group_json)
      @base = base
      populate(group_json)
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

    def populate(group_json)
      puts group_json.inspect
      @rackspace_id = group_json['id']
      @name = group_json['name']
      unless group_json['servers'].nil?
        @servers = @base.servers.select{|server| group_json['servers'].include? server.rackspace_id}
      end
    end
  end
end