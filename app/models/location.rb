class Location < ActiveRecord::Base
	belongs_to :user
	validates :user, presence: true
	validates :lat, presence: true
	validates :lng, presence: true

	acts_as_mappable

	#Location.within(11, origin: [59.93629557047682,30.49914868649344])
	def self.get_user_by_datetime_and_radius(datetime, radius, location, current_user_id)
		result = Location.select("DISTINCT ON (users.id) users.*, locations.*")
						 .joins(:user)
						 .where("locations.created_at >= :datetime_start AND 
						 		 locations.created_at <= :datetime_end AND
						 		 locations.user_id != :user_id", {datetime_start: datetime - 30.minutes,
						 		 								  datetime_end: datetime + 30.minutes,
						 		 								  user_id: current_user_id})
						 .within(radius, origin: location)
	end
end
