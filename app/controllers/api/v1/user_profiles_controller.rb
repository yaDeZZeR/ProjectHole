class Api::V1::UserProfilesController < Api::V1::BaseController
	skip_before_filter :verify_authenticity_token,
	                 :if => Proc.new { |c| c.request.format == 'application/json' }

	respond_to :json

	def create
		simple_json_response("Create profile") do
			
		end
	end
end