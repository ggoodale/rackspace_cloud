module RackspaceCloud
  class Flavor
    attr_reader :name, :disk, :ram, :rackspace_id

    def initialize(flavor_json)
      @rackspace_id = flavor_json['id']
      @name         = flavor_json['name']
      @disk         = flavor_json['disk']
      @ram          = flavor_json['ram']
    end
    
    def to_i
      @rackspace_id
    end
  end
end

