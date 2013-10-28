class Questionnaire < ActiveRecord::Base
  has_many :questions, :order => 'questions.order'
  has_many :answer_sheets
  
  def validate
    return if @questions_doc.nil? || @questions_doc.empty?
    
    # iterate the docs to extract questions
    yp = YAML::load_documents(@questions_doc) do |doc|
      if doc.nil?
        errors.add_to_base("严重格式错误")
        return
      end
      if doc["question"].nil?
        errors.add_to_base("有一个问题没有指定显示顺序")
        next
      end      
      if doc["type"].nil? || !["QA", "SC", "MC"].include?(doc["type"])
        errors.add_to_base("question " + doc["question"].to_s + ": 问题类型错误，请在QA, SC, MC中选择一个")
        next
      end
      if !doc["size"].nil? && !["S", "M", "L"].include?(doc["size"])
        errors.add_to_base("question " + doc["question"].to_s + ": 答案框大小错误，请在S, M, L中选择一个")
        next
      end
      if doc["content"].nil? || doc["content"].empty?
        errors.add_to_base("question " + doc["question"].to_s + ": 问题内容不能为空")
        next
      end
      if (doc["type"] == "SC" || doc["type"] == "MC") && (doc["options"].nil? || doc["options"].empty?)
        errors.add_to_base("question " + doc["question"].to_s + ": 单选和多选类型要有选择项")
        next
      end
    end
  end
  
  def questions_doc 
    if @questions_doc.nil? && questions.size > 0
      @questions_doc = ""
      self.questions.each do |q|
        @questions_doc << q.to_doc
      end
    end
    
    @questions_doc
  end
  
  def questions_doc=(questions_doc)
    @questions_doc = questions_doc
  end
  
  def save
  
    if !self.questions.empty?
       Question.delete_all ["questionnaire_id = ?", self.id] if !self.id.nil?
    end
    
    if !@questions_doc.nil? && !@questions_doc.empty?
      
      # iterate the docs to extract questions
      YAML::load_documents(@questions_doc) do |doc|
        question = Question.new(
          :order => doc["question"],
          :option_type => doc["type"],
          :answer_size => doc["size"],          
          :content => doc["content"]
        )
        
        question.show_as_stat = false if doc["stat"] == false        
        # QA, default 'M'
        question.answer_size = "M" if question.option_type == "QA" && question.answer_size.nil?
        
        if question.option_type != "QA" && !doc["options"].nil?
          # extract options for one question
          i = 1
          doc["options"].each do |option_content|
            question.options << Option.new(
              :order => i,
              :content => option_content
            )
            i += 1
          end
        end
        
        # add the question to the questionnaire
        self.questions << question
      end
    end
    
    super
    
  end
  
end
