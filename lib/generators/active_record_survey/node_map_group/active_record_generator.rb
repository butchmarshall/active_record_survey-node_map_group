require "generators/active_record_survey/node_map_group/active_record_survey_node_map_group_generator"
require "generators/active_record_survey/node_map_group/next_migration_version"
require "rails/generators/migration"
require "rails/generators/active_record"

# Extend the HasDynamicColumnsGenerator so that it creates an AR migration
module ActiveRecordSurvey
	class NodeMapGroup < ActiveRecord::Base
		class ActiveRecordGenerator < ::ActiveRecordSurveyGenerator
			include Rails::Generators::Migration
			extend NextMigrationVersion

			source_paths << File.join(File.dirname(__FILE__), "templates")

			def create_migration_file
				migration_template "migration_0.0.1.rb", "db/migrate/add_active_record_survey_node_map_group.rb"
			end

			def self.next_migration_number(dirname)
				::ActiveRecord::Generators::Base.next_migration_number dirname
			end
		end
	end
end
