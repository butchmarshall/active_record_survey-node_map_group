require 'spec_helper'

describe ActiveRecordSurvey::NodeMapGroup, :node_map_group_spec => true do
	describe "#build_questions" do
		before(:each) do
			@survey = FactoryGirl.build(:survey1)
			@survey.save

			@q1 = @survey.questions.select { |i| i.text == "Question #1" }.first
			@q1_a1 = @q1.answers.select { |i| i.text == "Q1 Answer #1" }.first
			@q1_a2 = @q1.answers.select { |i| i.text == "Q1 Answer #2" }.first

			@q2 = @survey.questions.select { |i| i.text == "Question #2" }.first
			@q2_a2 = @q2.answers.select { |i| i.text == "Q2 Answer #2" }.first

			@q3 = @survey.questions.select { |i| i.text == "Question #3" }.first
			@q3_a1 = @q3.answers.select { |i| i.text == "Q3 Answer #1" }.first
			@q3_a2 = @q3.answers.select { |i| i.text == "Q3 Answer #2" }.first

			@q4 = @survey.questions.select { |i| i.text == "Question #4" }.first
			@q5 = @survey.questions.select { |i| i.text == "Question #5" }.first
		end
		it 'should work', :focus => true do
			page1 = ActiveRecordSurvey::NodeMapGroup.new(:survey => @survey)
			page1.build_questions([@q1.id])
			expect(page1.save).to eq(true)

			page2 = ActiveRecordSurvey::NodeMapGroup.new(:survey => @survey)
			page2.build_questions([
				@q2.id,
				{ :question_id => @q3.id, :previous_id => @q2_a2.id }
			])
			expect(page2.save).to eq(true)
			expect(page2.node_maps.length).to eq(2)

			page3 = ActiveRecordSurvey::NodeMapGroup.new(:survey => @survey)
			page3.build_questions([
				{ :question_id => @q3.id, :previous_id => @q1_a2.id },
				{ :question_id => @q4.id, :previous_id => @q3_a1.id },
				{ :question_id => @q4.id, :previous_id => @q3_a2.id }
			])
			expect(page3.save).to eq(true)
			expect(page3.node_maps.length).to eq(3)
		end

		describe 'when there many node_map paths to choose from' do
			it 'should select the minimum required node_maps' do
				page = ActiveRecordSurvey::NodeMapGroup.new(:survey => @survey)
				page.build_questions([
					{ :question_id => @q3.id, :previous_id => @q1_a2.id },
					{ :question_id => @q4.id, :previous_id => @q3_a1.id },
					{ :question_id => @q4.id, :previous_id => @q3_a2.id }
				])
				expect(page.save).to eq(true)
				expect(page.node_maps.length).to eq(3)
			end

			it 'should not care about order' do
				page = ActiveRecordSurvey::NodeMapGroup.new(:survey => @survey)
				page.build_questions([
					{ :question_id => @q4.id, :previous_id => @q3_a2.id },
					{ :question_id => @q4.id, :previous_id => @q3_a1.id },
					{ :question_id => @q3.id, :previous_id => @q1_a2.id }
				])
				expect(page.save).to eq(true)
				expect(page.node_maps.length).to eq(3)
			end
		end
	end

	describe "#build_question" do
		it 'should work' do
			survey = FactoryGirl.build(:survey2)
			survey.save

			q1 = survey.questions.select { |i| i.text == "Question #1" }.first
			q1_a1 = q1.answers.select { |i| i.text == "Q1 Answer #1" }.first
			q1_a2 = q1.answers.select { |i| i.text == "Q1 Answer #2" }.first

			q2 = survey.questions.select { |i| i.text == "Question #2" }.first
			q2_a1 = q2.answers.select { |i| i.text == "Q2 Answer #1" }.first
			q2_a2 = q2.answers.select { |i| i.text == "Q2 Answer #2" }.first

			q3 = survey.questions.select { |i| i.text == "Question #3" }.first
			q3_a1 = q3.answers.select { |i| i.text == "Q3 Answer #1" }.first
			q3_a2 = q3.answers.select { |i| i.text == "Q3 Answer #2" }.first

			q4 = survey.questions.select { |i| i.text == "Question #4" }.first
			q4_a1 = q3.answers.select { |i| i.text == "Q4 Answer #1" }.first
			q4_a2 = q3.answers.select { |i| i.text == "Q4 Answer #2" }.first

			q5 = survey.questions.select { |i| i.text == "Question #5" }.first

			page1 = ActiveRecordSurvey::NodeMapGroup.create(:survey => survey)
			page2 = ActiveRecordSurvey::NodeMapGroup.create(:survey => survey)
			page3 = ActiveRecordSurvey::NodeMapGroup.create(:survey => survey)
			page4 = ActiveRecordSurvey::NodeMapGroup.create(:survey => survey)

			# Add Q1 -> Page 1
			# Success
			expect(page1.build_question(q1)).to eq(true)
			expect(page1.node_maps.length).to eq(1)
			# Fails due to branching
			expect(page1.build_question(q2)).to eq(false)
			expect(page1.node_maps.length).to eq(1)
			# Fails due to branching
			expect(page1.build_question(q2, q1_a1)).to eq(false)
			expect(page1.node_maps.length).to eq(1)

			# Add Q2 -> Page 2
			# Success
			expect(page2.build_question(q2)).to eq(true)
			expect(page2.node_maps.length).to eq(1)
			# Failures due to no direct link Q2 -> Q3 via q2_a1
			expect(page2.build_question(q3, q2_a1)).to eq(false)
			expect(page2.node_maps.length).to eq(1)
			# Failures due to multiple branching paths to Q4
			expect(page2.build_question(q4, q2_a2)).to eq(true)
			expect(page2.node_maps.length).to eq(2)

			# Add Q3 -> Page 3
			# Success
			expect(page3.build_question(q3)).to eq(true)
			expect(page3.node_maps.length).to eq(1)
			# Failures due to no direct link Q3 -> Q2 via q3_a1
			expect(page3.build_question(q2, q3_a1)).to eq(false)
			expect(page3.node_maps.length).to eq(1)
			# Failures due to multiple branching paths to Q4
			expect(page3.build_question(q4, q2_a1)).to eq(true)
			expect(page3.node_maps.length).to eq(2)

			# Add Q4, Q5 -> Page 3
			expect(page4.build_question(q4)).to eq(true)
			expect(page4.node_maps.length).to eq(4)
			# Q5 can only be gotten to via Q4, so we're good
			expect(page4.build_question(q5)).to eq(true)
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
end
