class Api::V1::NotConfirmedUsersController < Api::V1::BaseController
	skip_before_filter :verify_authenticity_token,
	                 :if => Proc.new { |c| c.request.format == 'application/json' }

	respond_to :html

	skip_before_filter :authenticate_user_from_token!

	def confirm
		not_conf_user = NotConfirmedUser.where({id: params[:id], token: params[:token]}).first
		@is_confirm = false
		@header = "Упс, надеюсь, что ты просто растяпа!"
		@sub_header = "Ссылка не действительна."		
		if !not_conf_user.nil?
			@is_confirm = true
			@header = "Я рад, что ты смог .!."
			@sub_header = "Почта подтверждена."
			user = User.create({login: not_conf_user.login,
						 password: not_conf_user.password,
						 password_confirmation: not_conf_user.password})
			not_conf_user.destroy
		end

		respond_to do |format|
			format.html
			format.json do 
				simple_json_response("Email confirm") do 
					i = {
						is_active_link: @is_confirm
					}
				end
			end
		end
	end
end