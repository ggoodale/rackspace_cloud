# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rackspace_cloud}
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Grant Goodale"]
  s.date = %q{2009-07-22}
  s.description = %q{Gem enabling the management of Rackspace Cloud Server instances.}
  s.email = %q{grant@moreblinktag.com}
  s.extra_rdoc_files = [
    "README"
  ]
  s.files = [
    "MIT-LICENSE",
     "README",
     "Rakefile",
     "VERSION",
     "init.rb",
     "install.rb",
     "lib/rackspace_cloud.rb",
     "lib/rackspace_cloud/base.rb",
     "lib/rackspace_cloud/flavor.rb",
     "lib/rackspace_cloud/image.rb",
     "lib/rackspace_cloud/server.rb",
     "rackspace_cloud.gemspec",
     "test/authentication_test.rb",
     "test/configuration_test.rb",
     "test/test_helper.rb"
  ]
  s.homepage = %q{http://github.com/ggoodale/rackspace_cloud}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{Gem enabling the management of Rackspace Cloud Server instances}
  s.test_files = [
    "test/authentication_test.rb",
     "test/configuration_test.rb",
     "test/test_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<patron>, [">= 0.4.0"])
    else
      s.add_dependency(%q<patron>, [">= 0.4.0"])
    end
  else
    s.add_dependency(%q<patron>, [">= 0.4.0"])
  end
end
