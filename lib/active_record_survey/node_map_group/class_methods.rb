module ActiveRecordSurvey
	class NodeMapGroup < ActiveRecord::Base
		module ClassMethods
			def self.extended(base)
				base.has_many :node_maps, :class_name => "ActiveRecordSurvey::NodeMap", :foreign_key => :active_record_survey_api_node_map_group_id
				base.belongs_to :survey, :class_name => "ActiveRecordSurvey::Survey", :foreign_key => :active_record_survey_id
				base.validates_presence_of :survey
				base.validate :validate_node_maps
			end
		end
	end
end