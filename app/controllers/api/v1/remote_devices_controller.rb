class Api::V1::RemoteDevicesController < Api::V1::BaseController
	skip_before_filter :verify_authenticity_token,
	                 :if => Proc.new { |c| c.request.format == 'application/json' }

	respond_to :json

	def update_ip
		simple_json_response("Update ip address") do
			device = current_user.remote_devices.where({id: params[:device_id]}).first
			unless device.nil?
				device.update_attributes({ip_address: params[:ip_address]})
			else
				raise UserException.new("Device ID not exist for current user")
			end
		end
	end

	def index
		simple_json_response("Control Device") do
			device = current_user.remote_devices.where({id: params[:device_id]}).first
			unless device.nil?
				device.update_attributes({ip_address: request.remote_ip})
			else
				raise UserException.new("Device ID not exist for current user")
			end
			i = {
				control_id: RemoteDevice.where({id: params[:device_id]}).first.user.ip_address,
				translation_info: {
					video_qualite: device.video_qualite
				}
			}
		end
	end
end