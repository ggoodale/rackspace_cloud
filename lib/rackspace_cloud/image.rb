module RackspaceCloud
  class Image

    MAX_RACKSPACE_IMAGE_ID = 10 # the highest id in use by a standard rackspace image (vs. a user backup)

    attr_reader :name, :created, :updated, :status, :progress, :rackspace_id, :base
    
    class << self
      def create_from_server(server, name=nil)
        name ||= generate_timestamped_name(server)
        image_json = server.base.request("/images", :method => :post, :data => {'image' => {'name' => name, 'serverId' => @rackspace_id}})['image']
        new_image = RackspaceCloud::Image.new(image_json)
        @images[new_image.rackspace_id] = new_image
        new_image
      end
    end
    
    def initialize(base, image_json)
      @base = base
      populate(image_json)
    end

    def delete
      raise RuntimeError, "Can't delete Rackspace standard images" if @rackspace_id <= MAX_RACKSPACE_IMAGE_ID
      @base.request("/images/#{@rackspace_id}", :method => :delete)
    end
    
    def to_i
      @rackspace_id
    end
    
    def refresh
      populate(@base.request("/images/#{@rackspace_id}")['image'])
      self
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
    
    def generate_timestamped_name(server)
      "#{server.downcase.gsub!(/\W/, "-")}-#{Time.nowTime.now.strftime('%Y%m%d%H%M%S%z')}"
    end
  end
end