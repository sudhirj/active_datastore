# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_datastore/version'

Gem::Specification.new do |spec|
  spec.name          = "active_datastore"
  spec.version       = ActiveDatastore::VERSION
  spec.authors       = ["Sudhir Jonathan"]
  spec.email         = ["sudhir.j@gmail.com"]
  spec.description   = "ODM (Object-Document-Mapper) for the Google Cloud Datastore."
  spec.summary       = "ODM (Object-Document-Mapper) for the Google Cloud Datastore."
  spec.homepage      = "https://github.com/sudhirj/active_datastore"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
