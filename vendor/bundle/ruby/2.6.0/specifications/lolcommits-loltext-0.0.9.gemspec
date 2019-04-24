# -*- encoding: utf-8 -*-
# stub: lolcommits-loltext 0.0.9 ruby lib

Gem::Specification.new do |s|
  s.name = "lolcommits-loltext".freeze
  s.version = "0.0.9"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "allowed_push_host" => "https://rubygems.org", "bug_tracker_uri" => "https://github.com/lolcommits/lolcommits-loltext/issues", "changelog_uri" => "https://github.com/lolcommits/lolcommits-loltext/blob/master/CHANGELOG.md", "homepage_uri" => "https://github.com/lolcommits/lolcommits-loltext", "source_code_uri" => "https://github.com/lolcommits/lolcommits-loltext" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Matthew Hutchinson".freeze]
  s.date = "2018-05-24"
  s.description = "  Overlay the commit message and sha on your lolcommit. Configure text style,\n  positioning and an optional transparent overlay.\n".freeze
  s.email = ["matt@hiddenloop.com".freeze]
  s.homepage = "https://github.com/lolcommits/lolcommits-loltext".freeze
  s.licenses = ["LGPL-3".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.1".freeze)
  s.rubygems_version = "3.0.3".freeze
  s.summary = "lolcommits commit message annotation plugin".freeze

  s.installed_by_version = "3.0.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<lolcommits>.freeze, [">= 0.11.0"])
      s.add_development_dependency(%q<bundler>.freeze, [">= 0"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<minitest>.freeze, [">= 0"])
      s.add_development_dependency(%q<simplecov>.freeze, [">= 0"])
    else
      s.add_dependency(%q<lolcommits>.freeze, [">= 0.11.0"])
      s.add_dependency(%q<bundler>.freeze, [">= 0"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<minitest>.freeze, [">= 0"])
      s.add_dependency(%q<simplecov>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<lolcommits>.freeze, [">= 0.11.0"])
    s.add_dependency(%q<bundler>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<minitest>.freeze, [">= 0"])
    s.add_dependency(%q<simplecov>.freeze, [">= 0"])
  end
end
