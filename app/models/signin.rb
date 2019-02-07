class Signin < ActiveRecord::Base
   belongs_to :provider
   belongs_to :user
   validates :user_id, presence: true
   validates :provider_id, presence: true
   validates :date, presence: true
end
