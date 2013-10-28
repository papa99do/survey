class PopulateData < ActiveRecord::Migration
  def self.up
    questionnaire = Questionnaire.create :title => 'hello', :description => 'hello world', :status => 'published'
    
    question1 = Question.create :questionnaire_id => questionnaire.id, :option_type => 'SC', :content => 'Your sex?', :order => 1
    Option.create :question_id => question1.id, :content => 'male', :order => 1;
    Option.create :question_id => question1.id, :content => 'female', :order => 2;
    
    question2 = Question.create :questionnaire_id => questionnaire.id, :option_type => 'SC', :answer_size => 'S', :content => 'Your kind?', :order => 2
    Option.create :question_id => question2.id, :content => '我是good', :order => 1;
    Option.create :question_id => question2.id, :content => 'bad', :order => 2;
    
    question3 = Question.create :questionnaire_id => questionnaire.id, :option_type => 'MC', :content => 'Your type?', :order => 3
    Option.create :question_id => question3.id, :content => 'gentel', :order => 1;
    Option.create :question_id => question3.id, :content => 'temper', :order => 2;
    Option.create :question_id => question3.id, :content => 'easy', :order => 3;
    
    question4 = Question.create :questionnaire_id => questionnaire.id, :option_type => 'MC', :answer_size => 'M', :content => 'Your lucky number?', :order => 4
    Option.create :question_id => question4.id, :content => '123', :order => 1;
    Option.create :question_id => question4.id, :content => '111', :order => 2;
    Option.create :question_id => question4.id, :content => '222', :order => 3;
    
    question5 = Question.create :questionnaire_id => questionnaire.id, :option_type => 'QA', :answer_size => 'L', :show_as_stat => false, :content => 'Who are you?', :order => 5
    
  end

  def self.down
    Questionnaire.delete_all
  end
end
