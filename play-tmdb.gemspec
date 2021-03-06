# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'play-tmdb/version'

Gem::Specification.new do |s|
  s.name = "play-tmdb"
  s.version = Play::Tmdb::VERSION
  s.authors = ["Halisson Bruno Vitor"]
  s.email = ["halissonvit@gmail.com"]
  s.homepage = "http://github.com/halissonvit/play-tmdb"
  s.summary = %q{A tmdb api wrapper}
  s.description = %q{Play with the tmdb api.}

  s.rubyforge_project = "play-tmdb"

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"

  s.add_runtime_dependency(%q<deepopenstruct>, [">= 0.1.2"])
  s.add_runtime_dependency(%q<json>, [">= 0"])
  s.add_runtime_dependency(%q<addressable>, [">= 0"])
  s.add_runtime_dependency(%q<yajl-ruby>, [">= 0"])
  s.add_runtime_dependency(%q<curb>, [">= 0"])
  s.add_development_dependency(%q<webmock>, [">= 0"])
end
