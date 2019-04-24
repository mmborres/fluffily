# -*- encoding: utf-8 -*-
# stub: lolcommits 0.12.1 ruby lib

Gem::Specification.new do |s|
  s.name = "lolcommits".freeze
  s.version = "0.12.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Matthew Rothenberg".freeze, "Matthew Hutchinson".freeze]
  s.date = "2018-03-27"
  s.description = "  lolcommits takes a snapshot with your webcam every time you git commit code,\n  and archives a lolcat style image with it. It's selfies for software\n  developers. `git blame` has never been so much fun.\n".freeze
  s.email = ["mrothenberg@gmail.com".freeze, "matt@hiddenloop.com".freeze]
  s.executables = ["lolcommits".freeze]
  s.files = ["bin/lolcommits".freeze]
  s.homepage = "http://mroth.github.com/lolcommits/".freeze
  s.licenses = ["LGPL-3".freeze]
  s.post_install_message = "  -------------------------------------------------------------------------------\n\n  Lolcommits: A quick message from the dev team! All plugins have now been\n  extracted to external gems. To continue using a (previously built-in) plugin,\n  first install the gem then configure to enable it e.g.\n\n    gem install lolcommits-twitter\n    lolcommits --config\n\n  See https://github.com/mroth/lolcommits/wiki/Configuring-Plugins for details.\n\n  Future plugin developers should check out this repo to get started:\n  https://github.com/lolcommits/lolcommits-plugin-sample\n\n  Happy Lol'ing!\n\n  -------------------------------------------------------------------------------\n".freeze
  s.required_ruby_version = Gem::Requirement.new(">= 2.1".freeze)
  s.requirements = ["imagemagick".freeze, "a webcam".freeze]
  s.rubygems_version = "3.0.3".freeze
  s.summary = "Capture webcam image on git commit for lulz.".freeze

  s.installed_by_version = "3.0.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<methadone>.freeze, ["~> 1.9.5"])
      s.add_runtime_dependency(%q<mercurial-ruby>.freeze, ["~> 0.7.12"])
      s.add_runtime_dependency(%q<mini_magick>.freeze, ["~> 4.8.0"])
      s.add_runtime_dependency(%q<launchy>.freeze, ["~> 2.4.3"])
      s.add_runtime_dependency(%q<open4>.freeze, ["~> 1.3.4"])
      s.add_runtime_dependency(%q<git>.freeze, ["~> 1.3.0"])
      s.add_runtime_dependency(%q<lolcommits-loltext>.freeze, ["~> 0.0.5"])
      s.add_development_dependency(%q<aruba>.freeze, [">= 0"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<rdoc>.freeze, [">= 0"])
      s.add_development_dependency(%q<pry>.freeze, [">= 0"])
      s.add_development_dependency(%q<rubocop>.freeze, [">= 0"])
      s.add_development_dependency(%q<minitest>.freeze, [">= 0"])
      s.add_development_dependency(%q<simplecov>.freeze, [">= 0"])
      s.add_development_dependency(%q<ffaker>.freeze, [">= 0"])
    else
      s.add_dependency(%q<methadone>.freeze, ["~> 1.9.5"])
      s.add_dependency(%q<mercurial-ruby>.freeze, ["~> 0.7.12"])
      s.add_dependency(%q<mini_magick>.freeze, ["~> 4.8.0"])
      s.add_dependency(%q<launchy>.freeze, ["~> 2.4.3"])
      s.add_dependency(%q<open4>.freeze, ["~> 1.3.4"])
      s.add_dependency(%q<git>.freeze, ["~> 1.3.0"])
      s.add_dependency(%q<lolcommits-loltext>.freeze, ["~> 0.0.5"])
      s.add_dependency(%q<aruba>.freeze, [">= 0"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<rdoc>.freeze, [">= 0"])
      s.add_dependency(%q<pry>.freeze, [">= 0"])
      s.add_dependency(%q<rubocop>.freeze, [">= 0"])
      s.add_dependency(%q<minitest>.freeze, [">= 0"])
      s.add_dependency(%q<simplecov>.freeze, [">= 0"])
      s.add_dependency(%q<ffaker>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<methadone>.freeze, ["~> 1.9.5"])
    s.add_dependency(%q<mercurial-ruby>.freeze, ["~> 0.7.12"])
    s.add_dependency(%q<mini_magick>.freeze, ["~> 4.8.0"])
    s.add_dependency(%q<launchy>.freeze, ["~> 2.4.3"])
    s.add_dependency(%q<open4>.freeze, ["~> 1.3.4"])
    s.add_dependency(%q<git>.freeze, ["~> 1.3.0"])
    s.add_dependency(%q<lolcommits-loltext>.freeze, ["~> 0.0.5"])
    s.add_dependency(%q<aruba>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<rdoc>.freeze, [">= 0"])
    s.add_dependency(%q<pry>.freeze, [">= 0"])
    s.add_dependency(%q<rubocop>.freeze, [">= 0"])
    s.add_dependency(%q<minitest>.freeze, [">= 0"])
    s.add_dependency(%q<simplecov>.freeze, [">= 0"])
    s.add_dependency(%q<ffaker>.freeze, [">= 0"])
  end
end
