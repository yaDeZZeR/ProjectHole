class Api::V1::NotConfirmedUsersController < Api::V1::BaseController
	skip_before_filter :verify_authenticity_token,
	                 :if => Proc.new { |c| c.request.format == 'application/json' }

	respond_to :html

	before_filter :check_api_key

	skip_before_filter :authenticate_user_from_token!

	def confirm
		not_conf_user = NotConfirmedUser.where({id: params[:id]}).first
		@is_confirm = false
		if !not_conf_user.nil?
			@is_confirm = true
			user = User.create({login: not_conf_user.login,
						 password: not_conf_user.password,
						 password_confirmation: not_conf_user.password})
			not_conf_user.destroy
		end
		render formats: :html
	end

	private
		def check_api_key
	      if params[:api_key] != ENV["EMAIL_KEY"]
	        simple_json_response("Not registered") do
	          raise UserException.new("Invalid API_KEY")
	        end
	      end
	    end
end