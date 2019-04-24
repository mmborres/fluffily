# -*- encoding: utf-8 -*-
# stub: spicy-proton 2.1.1 ruby lib

Gem::Specification.new do |s|
  s.name = "spicy-proton".freeze
  s.version = "2.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Chris Schmich".freeze]
  s.date = "2018-09-19"
  s.description = "".freeze
  s.email = "schmch@gmail.com".freeze
  s.homepage = "https://github.com/schmich/spicy-proton".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.1".freeze)
  s.rubygems_version = "3.0.3".freeze
  s.summary = "Generate a random English adjective-noun word pair.".freeze

  s.installed_by_version = "3.0.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<bindata>.freeze, ["~> 2.3"])
      s.add_development_dependency(%q<minitest>.freeze, ["~> 5.10"])
    else
      s.add_dependency(%q<bindata>.freeze, ["~> 2.3"])
      s.add_dependency(%q<minitest>.freeze, ["~> 5.10"])
    end
  else
    s.add_dependency(%q<bindata>.freeze, ["~> 2.3"])
    s.add_dependency(%q<minitest>.freeze, ["~> 5.10"])
  end
end
