class User < ActiveRecord::Base
  validates :user_name, presence: true, unique: true
end
