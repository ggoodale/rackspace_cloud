module RackspaceCloud
  class Image

    MAX_RACKSPACE_IMAGE_ID = 10 # the highest id in use by a standard rackspace image (vs. a user backup)

    attr_reader :name, :created, :updated, :status, :progress, :rackspace_id
    
    class << self
      def lookup_by_id(id)
        RackspaceCloud::IMAGES[id]
      end
    end
    
    def initialize(image_json)
      populate(image_json)
    end

    def delete
      raise RuntimeError, "Can't delete Rackspace standar images" if @rackspace_id <= MAX_RACKSPACE_IMAGE_ID
      RackspaceCloud.request("/images/#{@rackspace_id}", :method => :delete)
    end
    
    def to_i
      @rackspace_id
    end
    
    def refresh
      populate(RackspaceCloud.request("/images/#{@rackspace_id}")['image'])
      RackspaceCloud::IMAGES[@rackspace_id] = self
    end

    protected

    def populate(image_json)
      @rackspace_id = image_json['id']
      @name         = image_json['name']
      @created      = DateTime.parse(image_json['created'])
      @updated      = DateTime.parse(image_json['updated'])
      @status       = image_json['status']
      @progress     = image_json['progress']
    end
  end
end