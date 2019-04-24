# -*- encoding: utf-8 -*-
# stub: methadone 1.9.5 ruby lib

Gem::Specification.new do |s|
  s.name = "methadone".freeze
  s.version = "1.9.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["davetron5000".freeze]
  s.date = "2017-01-02"
  s.description = "Methadone provides a lot of small but useful features for developing a command-line app, including an opinionated bootstrapping process, some helpful cucumber steps, and some classes to bridge logging and output into a simple, unified, interface".freeze
  s.email = ["davetron5000 at gmail.com".freeze]
  s.executables = ["methadone".freeze]
  s.files = ["bin/methadone".freeze]
  s.homepage = "http://github.com/davetron5000/methadone".freeze
  s.rubygems_version = "3.0.3".freeze
  s.summary = "Kick the bash habit and start your command-line apps off right".freeze

  s.installed_by_version = "3.0.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<bundler>.freeze, [">= 0"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<rdoc>.freeze, ["~> 5.0"])
      s.add_development_dependency(%q<cucumber>.freeze, [">= 0"])
      s.add_development_dependency(%q<aruba>.freeze, ["= 0.5.1"])
      s.add_development_dependency(%q<simplecov>.freeze, ["~> 0.5"])
      s.add_development_dependency(%q<clean_test>.freeze, [">= 0"])
      s.add_development_dependency(%q<mocha>.freeze, ["= 0.13.2"])
      s.add_development_dependency(%q<sdoc>.freeze, ["= 1.0.0.rc1"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3"])
      s.add_development_dependency(%q<i18n>.freeze, ["= 0.6.1"])
    else
      s.add_dependency(%q<bundler>.freeze, [">= 0"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<rdoc>.freeze, ["~> 5.0"])
      s.add_dependency(%q<cucumber>.freeze, [">= 0"])
      s.add_dependency(%q<aruba>.freeze, ["= 0.5.1"])
      s.add_dependency(%q<simplecov>.freeze, ["~> 0.5"])
      s.add_dependency(%q<clean_test>.freeze, [">= 0"])
      s.add_dependency(%q<mocha>.freeze, ["= 0.13.2"])
      s.add_dependency(%q<sdoc>.freeze, ["= 1.0.0.rc1"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3"])
      s.add_dependency(%q<i18n>.freeze, ["= 0.6.1"])
    end
  else
    s.add_dependency(%q<bundler>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<rdoc>.freeze, ["~> 5.0"])
    s.add_dependency(%q<cucumber>.freeze, [">= 0"])
    s.add_dependency(%q<aruba>.freeze, ["= 0.5.1"])
    s.add_dependency(%q<simplecov>.freeze, ["~> 0.5"])
    s.add_dependency(%q<clean_test>.freeze, [">= 0"])
    s.add_dependency(%q<mocha>.freeze, ["= 0.13.2"])
    s.add_dependency(%q<sdoc>.freeze, ["= 1.0.0.rc1"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3"])
    s.add_dependency(%q<i18n>.freeze, ["= 0.6.1"])
  end
end
