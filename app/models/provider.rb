class Provider < ActiveRecord::Base
  has_many :signins
  has_many :users, through: :signins

  validates :name, presence: true

end
