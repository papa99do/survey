class Question < ActiveRecord::Base
  belongs_to  :questionnaire
  has_many    :options, :order => 'options.order'
  has_many    :answers
  
  def answer_contents
    all_answer_contents = answers.collect { |a| a.content }
    all_answer_contents.select {|c| !c.nil? && !c.empty? }
  end
  
  def to_doc
    doc = "---\n"
    doc << "question: " << self.order.to_s << "\n"
    doc << "type: " << self.option_type << "\n"
    doc << "size: " << self.answer_size << "\n" if !self.answer_size.nil?
    doc << "stat: " << self.show_as_stat.to_s << "\n" if !self.show_as_stat
    doc << "content: " << self.content << "\n"
    
    return doc if options.size < 1
    
    doc << "options:" << "\n"
    
    self.options.each do |option|
      doc << " - " << option.content << "\n"
    end
    
    doc
  end
  
end
