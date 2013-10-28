class StatisticsController < ApplicationController

  def index
    @questionnaires = Questionnaire.find :all, :conditions => "status in ('published', 'expired')"
  end
  
  def show_statistics
    @questionnaire = Questionnaire.find params[:id]
    @total_count = @questionnaire.answer_sheets.size
    
    return if @total_count < 1
    
    @questions = @questionnaire.questions.select {|q| q.show_as_stat?}
    
    @statistics = {}    
    @questions.each do |question|
      question.answers.each do |answer|
        answer.selected_options.split(',').each do |option|
          @statistics[option].nil? ? @statistics[option] = 1 : @statistics[option] += 1
        end
      end 
    end
  end
  
  def show_stat_detail
    @questionnaire = Questionnaire.find params[:id]
    answer_sheets_map, exclude_question_ids = deal_with_conditions params[:conditions], @questionnaire
    
    @questions = @questionnaire.questions.select {|q| q.show_as_stat? && q.option_type != "QA" && !exclude_question_ids.include?(q.id)}
    
    @total_counts = {}
    @statistics = {}
    answer_sheets_map.keys.each do |as_key|
      single_stat = {}
      get_answers_by_answer_sheets_ids(answer_sheets_map[as_key]).each do |answer|
        answer.selected_options.split(',').each do |option|
          single_stat[option].nil? ? single_stat[option] = 1 : single_stat[option] += 1
        end
      end
      @statistics[as_key] = single_stat
      @total_counts[as_key] = answer_sheets_map[as_key].size
    end
  end
  
  private
  def deal_with_conditions(conditions, questionnaire)
    answer_sheets_map = {}
    exclude_question_ids = []
    
    options = conditions.split ","
    options.each do |o|
      option = Option.find_by_id o[1..-1].to_i
      next if option.nil?
      
      exclude_question_ids << option.question_id 
      answer_sheets_map[option.id] = []
      Question.find_by_id(option.question_id).answers.each do |answer|
        answer_sheets_map[option.id] << answer.answer_sheet_id if answer.selected_options.split(",").include?(o[1..-1])
      end
    end    
    
    return answer_sheets_map, exclude_question_ids
  end
  
  def get_answers_by_answer_sheets_ids answer_sheet_ids
    Answer.find :all, :conditions => ["answer_sheet_id in (?)", answer_sheet_ids]
  end
  
end
