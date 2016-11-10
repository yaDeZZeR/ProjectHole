class Api::V1::HairColorsController < Api::V1::BaseController
	skip_before_filter :verify_authenticity_token,
	                 :if => Proc.new { |c| c.request.format == 'application/json' }

	respond_to :json

	def index
		simple_json_response("Hair colors") do
			HairColor.all.collect do |hair_color|
				hair_color.info
			end
		end
	end
end