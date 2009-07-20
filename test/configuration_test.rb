require File.join(File.dirname(__FILE__), 'test_helper.rb')

class ConfigurationTest < Test::Unit::TestCase
  context "A RackspaceCloud configuration" do
    setup do
      @config = {:user => "foo", :access_key => "aabbccdd"}
    end

    should "contain a username" do
      @config[:user] = nil
      assert_raise(ArgumentError) {
        RackspaceCloud::Base.new(@config)
      }
    end

    should "contain an authorization token" do
      @config[:access_key] = nil
      assert_raise(ArgumentError) {
        RackspaceCloud::Base.new(@config)
      }      
    end
    
    should "should be valid if all required parameters are specified" do
      assert_nothing_raised  { RackspaceCloud::Base.new(@config) }
    end
  end    
end
