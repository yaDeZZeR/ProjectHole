class Api::V1::UserProfilesController < Api::V1::BaseController
	skip_before_filter :verify_authenticity_token,
	                 :if => Proc.new { |c| c.request.format == 'application/json' }

	respond_to :json

	def create
		simple_json_response("Create profile") do
			user_profile = UserProfile.new(creation_params.merge({user_id: current_user.id}))
			raise UserException.new("Create profile failed", user_profile.errors) if !user_profile.save
		end
	end

	private

		def creation_params
			params.require(:profile).permit(:last_name, :first_name, :birthday, :sex, :height, :email, :hair_color_id)
		end
end