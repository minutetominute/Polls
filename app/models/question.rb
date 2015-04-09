class Question < ActiveRecord::Base
  validates :body, presence: true
  validates :poll_id, presence: true

  has_many :answer_choices,
    class_name: "AnswerChoice",
    foreign_key: :question_id,
    primary_key: :id

  belongs_to :poll,
    class_name: "Poll",
    foreign_key: :poll_id,
    primary_key: :id

  has_many :responses, through: :answer_choices, source: :responses

  def results
    answer_choices.each_with_object({}) do |choice, result|
      result[choice.body] = choice.responses.count
    end
  end

  def better_results
    answer_choices.includes(:responses).each_with_object({}) do |choice, result|
      result[choice.body] = choice.responses.length
    end
  end

  def dank_results
    results = question.find_by_sql(<<-SQL, )
    

    SQL
  end
end
