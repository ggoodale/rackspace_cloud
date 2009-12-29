module RackspaceCloud
  class Flavor
    attr_reader :name, :disk, :ram, :rackspace_id

    def initialize(params)
      @rackspace_id = params['id']
      @name         = params['name']
      @disk         = params['disk']
      @ram          = params['ram']
    end
    
    def to_i
      @rackspace_id
    end
  end
end

