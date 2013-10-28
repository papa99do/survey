class AnswerSheet < ActiveRecord::Base
  belongs_to :questionnaire
  has_many :answers
end
