class Api::V1::UsersController < Api::V1::BaseController
	skip_before_filter :verify_authenticity_token,
	                 :if => Proc.new { |c| c.request.format == 'application/json' }

	respond_to :json

	def set_fcm_token
		simple_json_response("FCM token") do
			User.set_fcm_token current_user.id, params[:fcm_token]
			info = {
				changed: true
			}
		end
	end
end