class AnswerChoice < ActiveRecord::Base
  validates :question_id, presence: true
  validates :body, presence: true
end
