module ActiveRecordSurvey
	class NodeMap < ActiveRecord::Base
		module ClassMethods
			def self.extended(base)
				base.belongs_to :node_map_group, :class_name => "ActiveRecordSurvey::NodeMapGroup", :foreign_key => :active_record_survey_api_node_map_group_id
			end
		end
	end
end