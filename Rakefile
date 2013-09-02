desc "pushes to github"
task "push" => ['build:readme'] do
  sh "hub push origin"
end

namespace :build do
  build_dir = 'build_files'
  sizes = ['small', 'medium', 'large']

  sizes.each do |size|
    desc "pushes gem to rubygems"
    task "push_#{size}" do
      sh "gem push rspec-with-args-#{File.read("#{build_dir}/version.txt")}.gem"
      Rake::Task["#{size}_version"].invoke
    end
  end

  desc "builds gem"
  task "build" => ['readme', 'date'] do
    sh "gem build rspec-with-args.gemspec"
  end


  desc "builds the readme file"
  task 'readme' do
    File.write("README.md", <<-README)
#rspec-with-args-#{File.read("#{build_dir}/version.txt")}
#{File.read("#{build_dir}/description.txt")}
##example specs
```ruby
#{File.read("spec/with_args_spec.rb")}
```
    README
    sh "git add README.md"
    sh "git commit --amend"
  end

  desc "builds gem date"
  task "date" do
    require 'date'
    File.write("#{build_dir}/date.txt", Date.today)
  end

  desc "bumps small version"
  task "small_version" do
    version = File.read("#{build_dir}/version.txt").split(/\./) rescue ['0','0','0']
    version = [version[0], version[1], version[2].next]
    File.write("#{build_dir}/version.txt", version.join('.'))
  end

  desc "bumps medium version"
  task "medium_version" do
    version = File.read("#{build_dir}/version.txt").split(/\./) rescue ['0','0','0']
    version = [version[0], version[1].next, version[2]]
    File.write("#{build_dir}/version.txt", version.join('.'))
  end

  desc "bumps large version"
  task "large_version" do
    version = File.read("#{build_dir}/version.txt").split(/\./) rescue ['0','0','0']
    version = [ version[0].next, version[1], version[2] ]
    File.write("#{build_dir}/version.txt", version.join('.'))
  end
end
