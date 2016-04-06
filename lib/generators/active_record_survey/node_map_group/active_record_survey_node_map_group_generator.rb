require 'rails/generators/base'
require 'active_record_survey/node_map_group/compatibility'

class ActiveRecordSurveyNodeMapGroupGenerator < Rails::Generators::Base
	source_paths << File.join(File.dirname(__FILE__), 'templates')
end
