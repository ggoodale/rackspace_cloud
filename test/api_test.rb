require File.join(File.dirname(__FILE__), 'test_helper.rb')

class APITest < Test::Unit::TestCase
  FAKE_SERVER_JSON = '{"servers":[{"id" : 1234,"name":"sample-server","imageId":2,"flavorId":1,"hostId":"e4d909c290d0fb1ca068ffaddf22cbd0","status":"ACTIVE","addresses":{"public":["67.23.10.132","67.23.10.131"],"private":["10.176.42.16"]},"metadata":{"Server Label":"Web Head 1","Image Version":"2.1"}}]}' 
  
  context "An authorized instance of RackspaceCloud::Base" do
    setup do    
      stub_external_api_calls
      @base = RackspaceCloud::Base.new(valid_configuration)
      @base.connect
    end
    
    context "when retrieving a detailed list of servers" do
      should "return the list of servers on success" do
        Patron::Session.any_instance.stubs(:request).returns(http_ok(FAKE_SERVER_JSON))
        assert_nothing_raised {@base.servers}
      end
      should "raise an exception when receiving a non-200 error" do
        Patron::Session.any_instance.stubs(:request).returns(http_bad_request) 
        assert_raises(RuntimeError) {@base.servers}
      end
    end
  end
end