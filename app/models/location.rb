class Location < ActiveRecord::Base
	belongs_to :user
	validates :user, presence: true
	validates :lat, presence: true
	validates :lng, presence: true

	acts_as_mappable

	#Location.within(11, origin: [59.93629557047682,30.49914868649344])
end
