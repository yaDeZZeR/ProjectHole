class NotConfirmedUser < ActiveRecord::Base
	validates :token, presence: true, uniqueness: true

	def self.generate_token
      loop do
        token = Devise.friendly_token
        break token unless NotConfirmedUser.where(token: token).first
      end
    end

    def self.clear
    	NotConfirmedUser.where("created_at <= :date_time", {date_time:  DateTime.now - 10.minutes})
    					.destroy_all
    end
end
