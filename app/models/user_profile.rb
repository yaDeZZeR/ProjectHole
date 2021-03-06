class UserProfile < ActiveRecord::Base
	belongs_to :user
	belongs_to :hair_color

	validates :birthday, presence: true

	enum sex: [:male, :female]

	def info 
		info = {
			last_name: self.last_name,
			first_name: self.first_name,
			sex: self.sex,
			birthday: self.birthday,
			height: self.height,
			email: self.email,
			hair_color_id: self.hair_color_id
		}
	end
end
