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

  def best_results
    results = ActiveRecord::Base.connection.execute(<<-SQL)
      SELECT
        answer_choices.body, COUNT(responses.id)
      FROM
        answer_choices
      LEFT OUTER JOIN
        responses
      ON
        responses.answer_choice_id = answer_choices.id
      WHERE
        answer_choices.question_id = #{self.id}
      GROUP BY
        answer_choices.id
    SQL
    results.values
  end

  def most_best_results
    results = answer_choices
    .select("answer_choices.*, COUNT(responses.id) AS responses_count")
    .joins("LEFT OUTER JOIN responses ON responses.answer_choice_id = answer_choices.id")
    .group("answer_choices.id")

    results.each_with_object({}) do |choice, result|
      result[choice.body] = choice.responses_count
    end
  end
end
