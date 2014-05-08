# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'winnow/version'

Gem::Specification.new do |spec|
  spec.name          = "winnow"
  spec.version       = Winnow::VERSION
  spec.authors       = ["Ulysse Carion"]
  spec.email         = ["ulyssecarion@gmail.com"]
  spec.description   = %q{A tiny Ruby library that implements Winnowing,
                          an algorithm for document fingerprinting.}
  spec.summary       = %q{Simple document fingerprinting and plagiarism detection.}
  spec.homepage      = "https://github.com/ucarion/winnow"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'rouge', '~> 1.3'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.14"
end
