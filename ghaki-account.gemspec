Gem::Specification.new do |s|

  s.name        = 'ghaki-account'
  s.summary     = 'Account login information'
  s.description = 'Collection of user / host login information helper objects.'

  s.version = IO.read(File.expand_path('VERSION')).chomp

  s.authors  = ['Gerald Kalafut']
  s.email    = 'gerald@kalafut.org'
  s.homepage = 'http://github.com/ghaki'

  # rubygem setup
  s.platform = Gem::Platform::RUBY
  s.required_rubygems_version = '>= 1.3.6'
  s.rubyforge_project = s.name

  # gem dependencies
  s.add_dependency 'highline', '>= 1.5.1'

  s.add_development_dependency 'rspec', '>= 2.4.0'
  s.add_development_dependency 'mocha', '>= 0.9.12'
  s.add_development_dependency 'rdoc',  '>= 3.9.4'

  # rdoc setup
  s.has_rdoc = true
  s.extra_rdoc_files = ['README']

  # manifest
  s.files = Dir['{lib,bin}/**/*'] + %w{ README LICENSE VERSION }
  s.test_files = Dir['spec/**/*_spec.rb','*spec/**/*_helper.rb']

  s.require_path = 'lib'
end
