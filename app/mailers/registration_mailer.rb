class RegistrationMailer < ApplicationMailer

	def confirm_email(email, id, token)
		@url  = GlobalHelper.host_for_confirm id, token
		mail(to: email, subject: 'Подтверждение электронной почты')
	end

end
