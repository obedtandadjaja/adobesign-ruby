$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'dealer_engine'
  s.version     = '0.0.0'
  s.authors     = ['Obed Tandadjaja']
  s.email       = ['obed.tandadjaja@gmail.com']
  s.summary     = 'Ruby library for AdobeSign.'
  s.description = ''
  s.homepage    = 'http://rubygems.org/gems/adobesign-ruby'
  s.license     = 'MIT'

  s.files = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| ::File.basename(f) }
  s.require_paths = ['lib']

  # Testing
  s.add_development_dependency 'faker', '~> 1.9'
  s.add_development_dependency 'rspec', '~> 3.8'

  # code analysis
  s.add_development_dependency 'pronto', '~> 0.9'
  s.add_development_dependency 'pronto-rubocop'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rubocop-rspec'
end
