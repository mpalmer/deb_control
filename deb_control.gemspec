# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'deb_control/version'

Gem::Specification.new do |spec|
  spec.name          = 'deb_control'
  spec.version       = DebControl::VERSION
  spec.authors       = ['Malte Swart']
  spec.email         = %w(mswart@devtation.de)
  spec.description   = 'Helpers to read debian control files'
  spec.summary       = File.read('README.md')
  spec.homepage      = 'https://github.com/mswart/deb_control'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w(lib)

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
