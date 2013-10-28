class SurveyController < ApplicationController

  caches_page :show_questionnaire

  def index
    @published_questionnaires = Questionnaire.find_all_by_status 'published'
  end
  
  def show_questionnaire
    @questionnaire = Questionnaire.find params[:id]
  end
  
  def submit_answers
    answer_sheet = AnswerSheet.create(
      :questionnaire_id => params[:id],
      :remote_ip => request.remote_ip
    )
    
    extract_answers(params).each do |answer|
      answer_sheet.answers << answer
    end
    
    redirect_to :action => "thankyou"
  end
  
  private
  def extract_answers(params)
    content_keys = params.keys.select {|k| k =~ /^c\d+/}
    question_keys = params.keys.select {|k| k =~ /^q\d+/}
    answers = {}
  
    question_keys.each do |key|
      qid = key[/q(\d+)/,1]
      if !qid.nil?
        oid = key[/o(\d+)/,1]
        if oid.nil?
          # single choice
          answers[qid] = Answer.new(
            :question_id => qid,
            :selected_options => params[key]
          )
        else
          # multiple choice
          if answers[qid].nil?
            answers[qid] = Answer.new(
              :question_id => qid,
              :selected_options => params[key]
            )
          else
            answers[qid].selected_options << "," << params[key]
          end
        end
      end
    end
    
    content_keys.each do |key|
      # content
      cid = key[/c(\d+)/,1]
      if !answers[cid].nil? && !answers[cid].selected_options[/o/].nil?
        answers[cid].content = params[key]
      end
    end
    
    return answers.values
  end
end
