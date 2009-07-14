# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rackspace_cloud}
  s.version = "0.1.0"
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Grant Goodale"]
  s.autorequire = %q{rackspace_cloud}
  s.date = %q{2009-07-14}
  s.description = %q{Gem enabling the management of Rackspace Cloud Server instances}
  s.email = %q{unknown@juixe.com}
  s.extra_rdoc_files = ["README", "MIT-LICENSE"]
  s.files = ["MIT-LICENSE", "README", "lib/rackspace_cloud.rb", "init.rb", "install.rb"]
  s.homepage = %q{http://github.com/ggoodale/rackspace_cloud}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{Gem enabling the management of Rackspace Cloud Server instances}
 
  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3
    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
