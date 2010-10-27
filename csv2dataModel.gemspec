spec = Gem::Specification.new do |s| 
  s.name = 'csv2dataModel'
  s.version = '0.0.1'
  s.author = 'Juan de Bravo'
  s.email = 'juan@pollinimi.net'
  s.homepage = 'http://github.com/juandebravo'
  s.platform = Gem::Platform::RUBY
  s.summary = 'A description of your project'
# Add your other files here if you make them
  s.files = %w(
    bin/csv2dataModel
  )
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','csv2dataModel2.rdoc']
  s.rdoc_options << '--title' << 'Git Like Interface' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'csv2dataModel'
end
