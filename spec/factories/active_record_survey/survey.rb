module FactoryGirlSurveyHelpers
	extend self
	def build_survey1(survey)
		q1 = survey.questions.build(:type => "ActiveRecordSurvey::Node::Question", :text => "Question #1", :survey => survey)
		q1_a1 = ActiveRecordSurvey::Node::Answer.new(:text => "Q1 Answer #1")
		q1_a2 = ActiveRecordSurvey::Node::Answer.new(:text => "Q1 Answer #2")
		q1.build_answer(q1_a1)
		q1.build_answer(q1_a2)

		q2 = survey.questions.build(:type => "ActiveRecordSurvey::Node::Question", :text => "Question #2", :survey => survey)
		q2_a1 = ActiveRecordSurvey::Node::Answer::Boolean.new(:text => "Q2 Answer #1")
		q2_a2 = ActiveRecordSurvey::Node::Answer::Boolean.new(:text => "Q2 Answer #2")
		q2.build_answer(q2_a1)
		q2.build_answer(q2_a2)

		q3 = survey.questions.build(:type => "ActiveRecordSurvey::Node::Question", :text => "Question #3", :survey => survey)
		q3_a1 = ActiveRecordSurvey::Node::Answer.new(:text => "Q3 Answer #1")
		q3_a2 = ActiveRecordSurvey::Node::Answer.new(:text => "Q3 Answer #2")
		q3.build_answer(q3_a1)
		q3.build_answer(q3_a2)

		q4 = survey.questions.build(:type => "ActiveRecordSurvey::Node::Question", :text => "Question #4", :survey => survey)

		q5 = survey.questions.build(:type => "ActiveRecordSurvey::Node::Question", :text => "Question #5", :survey => survey)
		
		q1_a1.build_link(q2)
		q1_a2.build_link(q3)
		q2_a2.build_link(q3)
		
		q3_a1.build_link(q4)
		q3_a2.build_link(q4)

		q4.build_link(q5)
	end

	def build_survey2(survey)
		q1 = ActiveRecordSurvey::Node::Question.new(:text => "Question #1", :survey => survey)
		q1_a1 = ActiveRecordSurvey::Node::Answer.new(:text => "Q1 Answer #1")
		q1_a2 = ActiveRecordSurvey::Node::Answer.new(:text => "Q1 Answer #2")
		q1.build_answer(q1_a1)
		q1.build_answer(q1_a2)

		q2 = ActiveRecordSurvey::Node::Question.new(:text => "Question #2", :survey => survey)
		q2_a1 = ActiveRecordSurvey::Node::Answer.new(:text => "Q2 Answer #1")
		q2_a2 = ActiveRecordSurvey::Node::Answer.new(:text => "Q2 Answer #2")
		q2.build_answer(q2_a1)
		q2.build_answer(q2_a2)

		q3 = ActiveRecordSurvey::Node::Question.new(:text => "Question #3", :survey => survey)
		q3_a1 = ActiveRecordSurvey::Node::Answer.new(:text => "Q3 Answer #1")
		q3_a2 = ActiveRecordSurvey::Node::Answer.new(:text => "Q3 Answer #2")
		q3.build_answer(q3_a1)
		q3.build_answer(q3_a2)

		q4 = ActiveRecordSurvey::Node::Question.new(:text => "Question #4", :survey => survey)
		q4_a1 = ActiveRecordSurvey::Node::Answer.new(:text => "Q4 Answer #1")
		q4_a2 = ActiveRecordSurvey::Node::Answer.new(:text => "Q4 Answer #2")
		q4.build_answer(q4_a1)
		q4.build_answer(q4_a2)
		
		q5 = ActiveRecordSurvey::Node::Question.new(:text => "Question #5", :survey => survey)

		q1_a1.build_link(q2)
		q1_a2.build_link(q3)

		q2_a1.build_link(q4)
		q2_a2.build_link(q4)

		q3_a1.build_link(q4)
		q3_a2.build_link(q4)

		q4_a1.build_link(q5)
		q4_a2.build_link(q5)
	end
end

FactoryGirl.define do	
	factory :survey, :class => 'ActiveRecordSurvey::Survey' do |f|
		
	end

	factory :survey1, parent: :survey do |f|
		after(:build) { |survey| FactoryGirlSurveyHelpers.build_survey1(survey) }
	end
	factory :survey2, parent: :survey do |f|
		after(:build) { |survey| FactoryGirlSurveyHelpers.build_survey2(survey) }
	end
end