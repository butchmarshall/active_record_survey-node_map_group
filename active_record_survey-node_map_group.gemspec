# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_record_survey/node_map_group/version'

Gem::Specification.new do |spec|
	spec.name          = "active_record_survey-node_map_group"
	spec.version       = ActiveRecordSurvey::NodeMapGroup::VERSION
	spec.authors       = ["Butch Marshall"]
	spec.email         = ["butch.a.marshall@gmail.com"]
	spec.summary       = "ActiveRecordSurvey NodeMap groups"
	spec.description   = "Create groupings of ActiveRecordSurvey branching paths with ActiveRecordSurvey::NodeMapGroup"
	spec.homepage      = "https://github.com/butchmarshall/active_record_survey-node_map_group"
	spec.license       = "MIT"

	spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
	spec.bindir        = "exe"
	spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
	spec.require_paths = ["lib"]

	spec.add_dependency "active_record_survey", ">= 0.1.38"

	if RUBY_PLATFORM == 'java'
		spec.add_development_dependency "jdbc-sqlite3", "> 0"
		spec.add_development_dependency "activerecord-jdbcsqlite3-adapter", "> 0"
	else
		spec.add_development_dependency "sqlite3", "> 0"
	end

	spec.add_development_dependency "database_cleaner"
	spec.add_development_dependency "factory_girl", "> 4.0"
	spec.add_development_dependency "bundler", "~> 1.7"
	spec.add_development_dependency "rake", "~> 10.0"
	spec.add_development_dependency "rspec", "~> 3.0"
end
