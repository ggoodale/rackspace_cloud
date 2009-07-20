require 'rubygems'
require 'test/unit'
gem 'thoughtbot-shoulda'

begin 
  require 'shoulda'
rescue LoadError
  abort "Unable to find thoughtbot-shoulda gem - please check that Shoulda is installed"
end
 
require File.join(File.dirname(__FILE__), '..', 'lib', 'rackspace_cloud')