# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tmdb/version'

Gem::Specification.new do |spec|
  spec.name          = "tmdb-movies"
  spec.version       = Tmdb::Movies::VERSION
  spec.authors       = ["Kelly Mahan"]
  spec.email         = ["kmahan@kmahan.com"]
  spec.summary       = %q{A gem for easy access to themoviedb.org's api.}
  spec.description   = %q{A gem for easy access to themoviedb.org's api.}
  spec.homepage      = "http://github.com/kellymahan/tmdb-movies"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_dependency "httparty"
end
