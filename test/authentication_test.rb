require File.join(File.dirname(__FILE__), 'test_helper.rb')

class AuthenticationTest < Test::Unit::TestCase
  context "An instance of Base created with a valid configuration" do 
    setup do
      stub_external_api_calls
      @base = RackspaceCloud::Base.new(valid_configuration)
      @base.stubs(:check_version_compatibility).returns(true)
      @base.stubs(:populate_flavors)
      @base.stubs(:populate_images)
      @base.stubs(:get_limits)
    end
    
    should "be able to authenticate successfully" do
      @base.connect
      assert @base.authorized?
    end
  end

  context "An instance of Base created with an invalid configuration" do 
    setup do
      stub_external_api_calls
      @base = RackspaceCloud::Base.new(invalid_configuration)
    end
    
    should "be able to authenticate successfully" do
      assert_raises(RackspaceCloud::AuthorizationError) {@base.connect}
      assert_equal false, @base.authorized?
    end
  end
end
