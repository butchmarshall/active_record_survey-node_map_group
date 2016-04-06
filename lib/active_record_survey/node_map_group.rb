require "active_support"
require "active_support/dependencies"
require "active_record"

require "active_record_survey"
require "active_record_survey/node_map_group/version"

require "active_record_survey/node_map_group/class_methods"
require "active_record_survey/node_map_group/instance_methods"

module ActiveRecordSurvey
   class NodeMapGroup < ActiveRecord::Base
   end
end

ActiveRecordSurvey::NodeMapGroup.send :include, ActiveRecordSurvey::NodeMapGroup::InstanceMethods
ActiveRecordSurvey::NodeMapGroup.send :extend, ActiveRecordSurvey::NodeMapGroup::ClassMethods