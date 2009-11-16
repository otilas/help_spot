require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "help_spot"
    gem.summary = %Q{A package for interacting with UserScape's HelpSpot product.}
    gem.description = %Q{A package for interacting with UserScape's HelpSpot product.}
    gem.email = "jnewland@gmail.com"
    gem.homepage = "http://github.com/jnewland/help_spot"
    gem.authors = ["Jamie Wilson","Jesse Newland"]
    gem.add_development_dependency "rspec"
    gem.add_development_dependency "yard"
    gem.add_dependency 'json'
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb', 'README.rdoc']
end