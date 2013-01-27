# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "help_spot"
  s.version = "0.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jesse Newland", "Josh Nichols"]
  s.date = "2013-01-27"
  s.description = "API wrapper for HelpSpot"
  s.email = "jnewland@gmail.com"
  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc",
    "TODO"
  ]
  s.files = [
    "Gemfile",
    "Gemfile.lock",
    "LICENSE",
    "README.rdoc",
    "Rakefile",
    "TODO",
    "help_spot.gemspec",
    "lib/help_spot.rb",
    "lib/help_spot/version.rb",
    "spec/fixtures/error.xml",
    "spec/fixtures/filter.get.xml",
    "spec/fixtures/private.timetracker.search.xml",
    "spec/fixtures/request.get.xml",
    "spec/fixtures/request.getCategories.xml",
    "spec/fixtures/request.getCustomFields.xml",
    "spec/fixtures/request.getStatusTypes.xml",
    "spec/fixtures/request.id.xml",
    "spec/fixtures/request.search.xml",
    "spec/fixtures/version.xml",
    "spec/help_spot_spec.rb",
    "spec/spec.opts",
    "spec/spec_helper.rb"
  ]
  s.homepage = "http://github.com/jnewland/help_spot"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.23"
  s.summary = "API wrapper for HelpSpot"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<hashie>, ["~> 1.0"])
      s.add_runtime_dependency(%q<httparty>, ["~> 0.5"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["= 1.3.0"])
      s.add_development_dependency(%q<fakeweb>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
    else
      s.add_dependency(%q<hashie>, ["~> 1.0"])
      s.add_dependency(%q<httparty>, ["~> 0.5"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, ["= 1.3.0"])
      s.add_dependency(%q<fakeweb>, [">= 0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
    end
  else
    s.add_dependency(%q<hashie>, ["~> 1.0"])
    s.add_dependency(%q<httparty>, ["~> 0.5"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, ["= 1.3.0"])
    s.add_dependency(%q<fakeweb>, [">= 0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
  end
end
