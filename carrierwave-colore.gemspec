Gem::Specification.new do |gem|
  gem.name           = 'carrierwave-colore'
  gem.version        = '0.1.0'
  gem.authors        = [ 'Luca Spiller' ]
  gem.email          = [ 'l.spiller@ifad.org' ]
  gem.description    = %q(Carrierwave adapter for Colore services)
  gem.summary        = %q(Carrierwave adapter for Colore services)
  gem.homepage       = ''

  gem.add_dependency 'colore-client', '0.1.4'

  gem.files          = `git ls-files`.split($/)
  gem.test_files     = gem.files.grep %r[^(test|spec|features)]
  gem.require_paths  = ['lib']
end