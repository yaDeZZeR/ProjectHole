class GlobalHelper

	def self.host
		"https://" + ENV["HOST"]
	end
	def self.host_for_confirm(id, token)
		self.host + "/api/v1/not_confirmed_users/confirm.json?id=#{id}&token=#{token}"
	end
end