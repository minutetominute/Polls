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
    Poll.find_by_sql(<<-SQL)
      SELECT
        polls.*, COUNT(questions.id)
      FROM
        polls
      INNER JOIN
        questions
      ON
        polls.id = questions.poll_id
      WHERE
        
      GROUP BY
        poll.id
    SQL
  end
end
