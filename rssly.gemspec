# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rssly/version'

Gem::Specification.new do |spec|
  spec.name          = "rssly"
  spec.version       = Rssly::VERSION
  spec.authors       = ["Nathan Kot"]
  spec.email         = ["me@nathankot.com"]
  spec.description   = %q{TODO: Write a gem description}
  spec.summary       = %q{TODO: Write a gem summary}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "feedbag", "~> 0.9"
  spec.add_dependency "feedjira", "~> 1.1"
  spec.add_dependency "ruby-readability", "~> 0.6"
  spec.add_dependency "sanitize", "~> 2.1"
  spec.add_dependency "ots", "~> 0.5"
  spec.add_dependency "addressable", "~> 2.3"
  spec.add_dependency "bloomfilter-rb", "~> 2.1"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

end