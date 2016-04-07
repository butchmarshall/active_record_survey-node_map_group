module ActiveRecordSurvey
	class NodeMapGroup < ActiveRecord::Base
		module InstanceMethods
			def self.included(base)
				base.table_name = :active_record_survey_api_node_map_groups
			end

			# Adds a question to the page
			# @param [Object]	Question object to add
			# @param [Object]	The answer to get to the question
			# @return [Boolean]	Whether the operation was successful
			def build_question(question, previous_answer = nil)
				results = self.survey.node_maps.select { |i|
					i.node === question && ((previous_answer.nil?)? true : i.parent && i.parent.node == previous_answer)
				}.collect { |question_node|
					if self.send(:node_map_valid?, question_node)
						self.node_maps << question_node
						true
					else
						false
					end
				}

				# At least one node_map was valid
				(results.length > 0 && !results.include?(false))
			end

			private
				def validate_node_maps
					self.node_maps.each { |node_map|
						if !self.send(:node_map_valid?, node_map)
							errors[:base] << "INVALID_NODE_MAP"
						end
					}
				end

				# Whether this node map is valid
				def node_map_valid?(potential_node_map)
					# Must inherit from ActiveRecordSurvey::Node::Question
					return false if !potential_node_map.node.class.ancestors.include?(::ActiveRecordSurvey::Node::Question)

					# Nothing else added - so yep - valid!
					return true if self.node_maps.length === 0

					# The node map shares a node already added
					return true if self.node_maps.collect { |nm| nm.node == potential_node_map.node }.include?(true)

					# There is an existing node where:
					#	- There is only one next question possible from it
					# 	- This node is that next question
					return true if self.node_maps.collect { |node_map|
						next_question = node_map.node.next_questions;
						(next_question.length === 1 && next_question.include?(potential_node_map.node))
					}.include?(true)

					# No criteria match - not valid
					false
				end
		end
	end
end