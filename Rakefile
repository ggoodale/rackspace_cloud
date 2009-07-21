require 'rubygems'
require 'rake'
require 'rake/testtask'
 
task :default => :test
 
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "rackspace_cloud"
    gemspec.summary = "Gem enabling the management of Rackspace Cloud Server instances"
    gemspec.description = "Gem enabling the management of Rackspace Cloud Server instances."
    gemspec.email = "grant@moreblinktag.com"
    gemspec.homepage = "http://github.com/ggoodale/rackspace_cloud"
    gemspec.authors = ["Grant Goodale"]
    gemspec.files.exclude("**/.gitignore")
    gemspec.add_dependency('patron', '>= 0.4.0')
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end
 
 
