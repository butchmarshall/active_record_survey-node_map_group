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

			# Builds questions
			#
			# From an array of questions (and question/answer key value pairs) builds all the node_map_groups to be associated with this node_map_group
			#
			# * *Args*    :
			#   - +array+ -> The array of questions
			# * *Returns* :
			#   - +boolean+ -> Whether successul or not
			# * *Raises* :
			#   - +StandardError+ -> Survey has not yet been associated
			#   - +ArgumentError+ -> Question or Answers do not exist
			#
			def build_questions(questions)
				# Must be associated with a survey first
				raise StandardError, "SURVEY_MISSING" if self.survey.nil?

				questions.each { |datum|
					# Find question by inputs
					question = case datum.class.to_s
					when 'Fixnum' then ActiveRecordSurvey::Node::Question.where(:id => datum, :survey => self.survey).first
					when 'Hash' then ActiveRecordSurvey::Node::Question.where(:id => datum[:question_id], :survey => self.survey).first
					else nil
					end

					# Don't continue if question does not exist
					raise ArgumentError, "INVALID_QUESTION" if question.nil?

					# Find answer by inputs
					previous_node = case datum.class.to_s
					when 'Hash' then ActiveRecordSurvey::Node.where(:id => datum[:previous_id], :survey => self.survey).first
					else nil
					end

					# Via Survey object, find all the node_maps that match the criteria passed
					question_node_maps = self.survey.node_maps.select { |node_map|
						node_map.node == question
					}

					# Filter list by the previous node
					question_node_maps.select! { |node_map| previous_node.node_maps.select { |i| i.children.include?(node_map) }.length > 0 } unless previous_node.nil?

					# Filter by existing node maps
					filtered = question_node_maps.select { |new_node_map|
						# Only keep new node_maps if there is an existing node_map that is an ancestor of it
						self.node_maps.select { |existing_node_map|
							# This is the only path we want - throw out the others
							new_node_map.is_decendant_of?(existing_node_map)
						}.length > 0
					}

					# At least one existing node_map was an ancestor of the one we're adding
					question_node_maps = filtered if filtered.length != 0

					# Now prune existing node maps
					# We are removing node_maps that are apart of paths that don't logically make sense anymore
					self.node_maps = self.node_maps.select { |existing_node_map|
						keep = true
						question_node_maps.select { |new_node_map|
							if existing_node_map.node != new_node_map.node && !existing_node_map.is_decendant_of?(new_node_map) && ! new_node_map.is_decendant_of?(existing_node_map)
								existing_node_map.node_map_group = nil
								keep = false
							end
						}
						keep
					}

					# After our investigation - no nodes found!
					raise ArgumentError, "QUESTION_NOT_FOUND" if question_node_maps.length === 0

					# Add the remaining nodes
					question_node_maps.each { |node_map|
						self.node_maps << node_map
					}
				}
				true
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

					# A question also linked to this node_group leads to this node
					# BUT - that previous question actually points to multiple questions
					return false if self.node_maps.select { |node_map|
						# This node map is the question before the one we're validating
						node_map.node.next_questions.include?(potential_node_map.node)
					}.collect { |node_map|
						node_map.node.next_questions.length === 1
					}.include?(false)

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