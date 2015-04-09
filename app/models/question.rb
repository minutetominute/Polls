class Question < ActiveRecord::Base
  validates :body, presence: true
  validates :poll_id, presence: true
end
