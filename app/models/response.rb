class Response < ActiveRecord::Base
  validates :user_id, presence: true
  validates :answer_choice_id, presence: true
  validate :respondent_has_not_already_answered_question
  validate :respondent_is_not_question_author

  belongs_to :answer_choice,
    class_name: "AnswerChoice",
    foreign_key: :answer_choice_id,
    primary_key: :id

  belongs_to :respondent,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id

  has_one :question, through: :answer_choice, source: :question

  def sibling_responses
    # question.responses.where.not(id: self.id)
    question.responses.where(<<-SQL, id: self.id)
      :id IS NULL
      OR
      responses.id != :id
    SQL
  end

  private
  def respondent_has_not_already_answered_question
    if sibling_responses.exists?(self.user_id)
      errors[:response] << "already answered"
    end
  end

  def respondent_is_not_question_author
    if question.poll.author_id == self.user_id
      errors[:response] << "cannot answer own question"
    end
  end
end
