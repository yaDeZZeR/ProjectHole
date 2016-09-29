class Api::V1::LocationsController < Api::V1::BaseController
	skip_before_filter :verify_authenticity_token,
	                 :if => Proc.new { |c| c.request.format == 'application/json' }

	skip_before_filter :authenticate_user_from_token!, :only => [:index]
	respond_to :json

	def create
		simple_json_response("Create User Location") do
			loc = Location.new (create_params.merge({user_id: current_user.id}))
			raise UserException.new("Error Create User Location", {location: loc.errors}) unless loc.save
			loc
		end
	end

	def index
		simple_json_response("Locations") do 
			User.where({login: params[:login]}).first.locations.collect do |a| 
				info = { lng: a.lng, lat: a.lat}
			end
		end
	end

	private
		def create_params
	      params.require(:location).permit(:lat, :lng)
	    end
end