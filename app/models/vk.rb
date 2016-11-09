class Vk < ActiveRecord::Base
	belongs_to :user

	validates :vk_id, presence: true
	validates :user_id, presence: true
end
