class User < ActiveRecord::Base
  validates :user_name, presence: true, uniqueness: true

  has_many :authored_polls,
    class_name: "Poll",
    foreign_key: :author_id,
    primary_key: :id

  has_many :responses,
    class_name: "Response",
    foreign_key: :user_id,
    primary_key: :id

  def completed_polls
    result = Poll.find_by_sql([<<-SQL, self.id, self.id])
      SELECT
        polls.*, COUNT(DISTINCT questions.id) AS num_poll_questions
      FROM
        polls
      LEFT OUTER JOIN
        questions
      ON
        polls.id = questions.poll_id
      LEFT OUTER JOIN
        (SELECT
          responses.*
        FROM
          responses
        WHERE
          responses.user_id = ?) user_responses
        ON
          user_responses.user_id = ?
      GROUP BY
        polls.id
      HAVING
        COUNT(DISTINCT questions.id) = COUNT(DISTINCT user_responses.id)
    SQL
    result.map { |r| [r.title, r.num_poll_questions] }
  end
end
