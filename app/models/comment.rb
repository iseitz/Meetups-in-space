class Comment < ActiveRecord::Base
  belongs_to :user
  validates :body, presence: true, length: { maximum: 1000 }
  validates :user, presence: true
  validates :meetup, presence: true
end
