module RackspaceCloud
  class Image
    attr_reader :name, :created, :updated, :status, :rackspace_id
    
    class << self
      def lookup_by_id(id)
        RackspaceCloud::IMAGES[id]
      end
    end
    
    def initialize(image_json)
      @rackspace_id = image_json['id']
      @name         = image_json['name']
      @created      = image_json['created']
      @updated      = image_json['updated']
      @status       = image_json['status']
    end
    
    def to_i
      @rackspace_id
    end
    
    def refresh
    end
  end
end