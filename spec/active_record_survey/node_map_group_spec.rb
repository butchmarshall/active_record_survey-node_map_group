require 'spec_helper'

describe ActiveRecordSurvey::NodeMapGroup, :node_map_group_spec => true do
	before(:each) do
		@survey = ActiveRecordSurvey::Survey.new()
		@survey.save

		@q1 = ActiveRecordSurvey::Node::Question.new(:text => "Question #1", :survey => @survey)
		@q1_a1 = ActiveRecordSurvey::Node::Answer.new(:text => "Answer #1 q1")
		@q1_a2 = ActiveRecordSurvey::Node::Answer.new(:text => "Answer #2 q1")
		@q1.build_answer(@q1_a1)
		@q1.build_answer(@q1_a2)

		@q2 = ActiveRecordSurvey::Node::Question.new(:text => "Question #2", :survey => @survey)
		@q2_a1 = ActiveRecordSurvey::Node::Answer.new(:text => "Answer #1 q2")
		@q2_a2 = ActiveRecordSurvey::Node::Answer.new(:text => "Answer #2 q2")
		@q2.build_answer(@q2_a1)
		@q2.build_answer(@q2_a2)

		@q3 = ActiveRecordSurvey::Node::Question.new(:text => "Question #3", :survey => @survey)
		@q3_a1 = ActiveRecordSurvey::Node::Answer.new(:text => "Answer #1 q3")
		@q3_a2 = ActiveRecordSurvey::Node::Answer.new(:text => "Answer #2 q3")
		@q3.build_answer(@q3_a1)
		@q3.build_answer(@q3_a2)

		@q4 = ActiveRecordSurvey::Node::Question.new(:text => "Question #4", :survey => @survey)
		@q4_a1 = ActiveRecordSurvey::Node::Answer.new(:text => "Answer #1 q4")
		@q4_a2 = ActiveRecordSurvey::Node::Answer.new(:text => "Answer #2 q4")
		@q4.build_answer(@q4_a1)
		@q4.build_answer(@q4_a2)
		
		@q5 = ActiveRecordSurvey::Node::Question.new(:text => "Question #5", :survey => @survey)

		@q1_a1.build_link(@q2)
		@q1_a2.build_link(@q3)

		@q2_a1.build_link(@q4)
		@q2_a2.build_link(@q4)

		@q3_a1.build_link(@q4)
		@q3_a2.build_link(@q4)

		@q4_a1.build_link(@q5)
		@q4_a2.build_link(@q5)

		@survey.save
	end

	it 'should work' do
		page1 = ActiveRecordSurvey::NodeMapGroup.create(:survey => @survey)
		page2 = ActiveRecordSurvey::NodeMapGroup.create(:survey => @survey)
		page3 = ActiveRecordSurvey::NodeMapGroup.create(:survey => @survey)
		page4 = ActiveRecordSurvey::NodeMapGroup.create(:survey => @survey)

		# Add Q1 -> Page 1
		# Success
		expect(page1.build_question(@q1)).to eq(true)
		expect(page1.node_maps.length).to eq(1)
		# Fails due to branching
		expect(page1.build_question(@q2)).to eq(false)
		expect(page1.node_maps.length).to eq(1)
		# Fails due to branching
		expect(page1.build_question(@q2, @q1_a1)).to eq(false)
		expect(page1.node_maps.length).to eq(1)

		# Add Q2 -> Page 2
		# Success
		expect(page2.build_question(@q2)).to eq(true)
		expect(page2.node_maps.length).to eq(1)
		# Failures due to no direct link Q2 -> Q3 via q2_a1
		expect(page2.build_question(@q3, @q2_a1)).to eq(false)
		expect(page2.node_maps.length).to eq(1)
		# Failures due to multiple branching paths to Q4
		expect(page2.build_question(@q4, @q2_a2)).to eq(true)
		expect(page2.node_maps.length).to eq(2)

		# Add Q3 -> Page 3
		# Success
		expect(page3.build_question(@q3)).to eq(true)
		expect(page3.node_maps.length).to eq(1)
		# Failures due to no direct link Q3 -> Q2 via q3_a1
		expect(page3.build_question(@q2, @q3_a1)).to eq(false)
		expect(page3.node_maps.length).to eq(1)
		# Failures due to multiple branching paths to Q4
		expect(page3.build_question(@q4, @q2_a1)).to eq(true)
		expect(page3.node_maps.length).to eq(2)

		# Add Q4, Q5 -> Page 3
		expect(page4.build_question(@q4)).to eq(true)
		expect(page4.node_maps.length).to eq(4)
		# Q5 can only be gotten to via Q4, so we're good
		expect(page4.build_question(@q5)).to eq(true)
		expect(page4.node_maps.length).to eq(12)

		expect(page1.save).to eq(true)
		expect(page2.save).to eq(true)
		expect(page3.save).to eq(true)
		expect(page4.save).to eq(true)

		expect(page1.new_record?).to eq(false)
		expect(page2.new_record?).to eq(false)
		expect(page3.new_record?).to eq(false)
		expect(page4.new_record?).to eq(false)
	end
end
