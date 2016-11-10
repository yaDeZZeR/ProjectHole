class HairColor < ActiveRecord::Base
	has_many :user_profile

	def info
		info = {
			id: self.id,
			hair_color: self.color
		}
	end
end
