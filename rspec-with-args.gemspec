build_dir = 'build_files'
Gem::Specification.new do |s|
  s.name        = 'rspec-with-args'
  s.homepage    = "https://github.com/kwstannard/rspec-with-args"
  s.version     = File.read("#{build_dir}/version.txt")
  s.date        = File.read("#{build_dir}/date.txt")
  s.summary     = "adding arguments to the subject"
  s.description = File.read("#{build_dir}/description.txt")
  s.authors     = `git log --format="%aN"`.split(/\n/)
  s.email       = 'kwstannard@gmail.com'
  s.files       = Dir["lib/*.rb"]
  s.test_files  = Dir["spec/*_spec.rb"]
  s.license     = 'MIT'
end
