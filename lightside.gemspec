require File.expand_path('../lib/lightside/version',  __FILE__)

Gem::Specification.new do |s|
  s.name          = 'lightside'
  s.version       = LightSide::VERSION
  s.date          = '2013-12-02'
  s.summary       = 'LightSide API'
  s.description   = 'Ruby wrapper for LightSide Web API'
  s.authors       = ['Tom Head']
  s.email         = 'tom.head@revolutionprep.com'
  s.homepage      = 'http://github.com/RevolutionK12/lightside'
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.homepage      = ""
  s.license       = 'MIT'
  s.require_paths = ["lib"]

  s.add_dependency 'rest-client'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'pry-nav'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-rspec'
end
