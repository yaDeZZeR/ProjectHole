class RegistrationMailer < ApplicationMailer

	def confirm_email(email, id)
		@url  = GlobalHelper.host_for_confirm id
		mail(to: email, subject: 'Подтверждение электронной почты')
	end

end
