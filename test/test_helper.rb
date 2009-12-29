require 'rubygems'
require 'test/unit'

{'shoulda' => 'thoughtbot-shoulda', 'mocha' => 'mocha'}.each do |lib, gem_name|
  begin 
    require lib
  rescue LoadError
    abort "Unable to find #{lib} - please check that #{gem_name} is installed"
  end
end
 require File.join(File.dirname(__FILE__), '..', 'lib', 'rackspace_cloud')

def valid_configuration
  {:user => "bob", :access_key => "valid"}
end

def invalid_configuration
  {:user => "bob", :access_key => "invalid"}
end

def fake_authorization_hash
  {
    'X-Server-Management-Url' => "http://test.host/smu",
    'X-Storage-Url '=> "http://test.host/su",
    'X-Storage-Token' => "storage_token",
    'X-CDN-Management-Url' => "http://test.host/cmu",
    'X-Auth-Token' => 'authorized'
  }
end

FAKE_FLAVORS = { 1 => RackspaceCloud::Flavor.new({'id' => 1, 'name' => '256 slice', 'disk' => 10, 'ram' => 256}) }
FAKE_IMAGES = { 8 => RackspaceCloud::Image.new(nil, {'id' => 8, 'name' => 'Ubuntu 9.04 (jaunty)', 'created' => DateTime.new.to_s, 'updated' => DateTime.new.to_s, 'status' => 'ACTIVE', 'progress' => nil})}
FAKE_LIMITS = { "absolute"=> {
                  "maxTotalRAMSize"   => 51200, 
                  "maxIPGroups"       => 25, 
                  "maxIPGroupMembers" => 25
                }, 
                
                "rate"=> [
                  {"regex" => ".*", "URI" => "*", "verb" => "PUT", "remaining" => 10, "unit" => "MINUTE", "value" => 10, "resetTime" => 1249936781}, 
                  {"regex" => "^/servers", "URI" => "/servers*", "verb" => "POST", "remaining" => 25, "unit" => "DAY", "value" => 25, "resetTime" => 1249936781},
                  {"regex" => "changes-since", "URI" => "*changes-since*", "verb" => "GET", "remaining" => 3, "unit" => "MINUTE", "value" => 3, "resetTime" => 1249936781},
                  {"regex" => ".*", "URI" => "*", "verb" => "DELETE", "remaining" => 600, "unit" => "MINUTE", "value" => 600, "resetTime" => 1249936781}, 
                  {"regex" => ".*", "URI" => "*", "verb" => "POST", "remaining" => 10, "unit" => "MINUTE", "value" => 10, "resetTime" => 1249936781}
                ]
              }

def stub_external_api_calls
  RackspaceCloud.stubs(:request_authorization).with(valid_configuration[:user], valid_configuration[:access_key]).returns(fake_authorization_hash)
  RackspaceCloud.stubs(:request_authorization).with(invalid_configuration[:user], invalid_configuration[:access_key]).raises(RackspaceCloud::AuthorizationError)

  RackspaceCloud::Base.any_instance.stubs({
    :populate_flavors => nil,
    :populate_images => nil,
    :get_limits => nil,
    :flavors => FAKE_FLAVORS,
    :images => FAKE_IMAGES,
    :limits => FAKE_LIMITS
  })
end

def http_ok(body=nil)
  headers = test_headers  
  headers['Content-Length'] = body.to_s.length if body
  mock("http_ok") do
    stubs(:status).returns(200)
    stubs(:headers).returns(headers)
    stubs(:body).returns(body.to_s)
  end
end

def http_bad_request
  mock("http_bad_request") do
    stubs(:status).returns(400)
    stubs(:headers).returns(test_headers)
    stubs(:body).returns(nil)
  end
end                  

def http_unauthorized
  mock("http_unauthorized") do
    stubs(:status).returns(401)
    stubs(:headers).returns(test_headers)
    stubs(:body).returns(nil)
  end
end

def http_over_limit
end

def http_bad_media_type
end

def http_bad_method
end

def http_item_not_found
end

def http_rescue_mode_in_use
end

def http_build_in_progress
end

def http_server_capacity_unavailable
end

def http_backup_or_resize_in_progress
end

def http_resize_not_allowed
end

def http_not_implemented
end

def test_headers 
  {
    "vary" => "Accept, Accept-Encoding", 
    "X-Varnish" => "1754063840", 
    "Via" => "1.1 varnish", 
    "Content-Type" => "application/json", 
    "Cache-Control" => "s-maxage=1800", 
    "Server" => "Apache-Coyote/1.1", 
    "Connection" => "keep-alive", 
    "Age" => "0"
  }
end

  