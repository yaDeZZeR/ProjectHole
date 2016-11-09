class Api::V1::VkController < Api::V1::BaseController
	skip_before_filter :verify_authenticity_token,
	                 :if => Proc.new { |c| c.request.format == 'application/json' }

	skip_before_filter :authenticate_user_from_token!
	respond_to :json

	def create
		simple_json_response("Vk auth") do
			begin
				info = {}
				vk = VkontakteApi.authorize(type: :app_server)
				res = vk.secure.checkToken( token: params[:vk_token], 
									  ip: "188.162.64.17",#request.remote_ip, 
									  client_secret: VkontakteApi.app_secret)
				vk_user = Vk.where({vk_id: res.user_id}).first
				if vk_user.nil?
					user = User.create({login: "vk" + res.user_id.to_s})
					Vk.create({user_id: user.id, vk_id: res.user_id})
					info[:is_new_user] = true
					info[:auth_token] = user.authentication_token
					info[:profile] = nil
				else
					info[:is_new_user] = false
					info[:auth_token] = vk_user.user.authentication_token
					vk_user.user.user_profile.nil? ? info[:profile] = nil : info[:profile] = vk_user.user.user_profile.info
				end				
				info
			rescue
				raise UserException.new("Vk authorization failed")
			end
		end
	end
end