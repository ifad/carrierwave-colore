# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'carrierwave/colore/version'

Gem::Specification.new do |spec|
  spec.name        = 'carrierwave-colore'
  spec.version     = CarrierWave::Colore::VERSION
  spec.authors     = ['Luca Spiller', 'Geremia Taglialatela']
  spec.email       = ['l.spiller@ifad.org', 'g.taglialatela@ifad.org']

  spec.summary     = 'Carrierwave adapter for Colore services'
  spec.description = 'Carrierwave adapter for Colore services'
  spec.homepage    = 'https://github.com/ifad/carrierwave-colore'
  spec.license     = 'MIT'

  spec.metadata['bug_tracker_uri'] = 'https://github.com/ifad/carrierwave-colore/issues'
  spec.metadata['source_code_uri'] = 'https://github.com/ifad/carrierwave-colore'

  spec.files         = `git ls-files -z -- {LICENSE,README.md,lib}`.split("\x0")
  spec.require_paths = ['lib']

  spec.platform              = Gem::Platform::RUBY
  spec.required_ruby_version = '>= 2.5'

  spec.add_dependency 'carrierwave', '~> 2.2'
  spec.add_dependency 'colore-client', '>= 0.2.0'

  spec.add_development_dependency 'byebug', '~> 11.1'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.10'
  spec.add_development_dependency 'simplecov', '>= 0.18.5', '< 0.22'
  spec.add_development_dependency 'simplecov-lcov', '~> 0.8.0'
end
