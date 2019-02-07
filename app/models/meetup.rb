class Meetup < ActiveRecord::Base

  THEMES = ["Sports", "Handmade", "Tech/IT", "Party", "Art", "Family", "Languages", "Nature and Adventure", "Health", "Slef-development", "Photography", "Cooking", "Writing", "Music", "Cinema", "Games", "Pets", "Dance", "Fashion/Beauty", "Business"]

  has_many :registrations
  has_many :users, through: :registrations
  has_many :comments
  validates :title, presence: true, length: { maximum: 500 }
  validates :theme, presence: true, inclusion: {in: THEMES}
  validates :date , presence: true
  validates :begin_time, presence: true
  validates :end_time, presence: true
  validates :location, presence: true
  validates :description, presence: true
  validates :user_id, presence: true

end
