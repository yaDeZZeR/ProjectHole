class EmailSender

	def self.send_email(email, id, token)
		puts "Send email to \"#{email}\""
		Rails.logger.info "Send email to \"#{email}\""
		res = RegistrationMailer.confirm_email(email, id, token).deliver_now
		Rails.logger.info "FCM answer: #{res}"
	end

end