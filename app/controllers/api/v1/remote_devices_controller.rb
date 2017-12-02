class Api::V1::RemoteDevicesController < Api::V1::BaseController
	skip_before_filter :verify_authenticity_token,
	                 :if => Proc.new { |c| c.request.format == 'application/json' }

	respond_to :json

	def update_ip
		simple_json_response("Update ip address") do
			device = current_user.remote_devices.where({remote_device_id: params[:device_id]}).first
			unless device.nil?
				device.update_attributes({ip_address: params[:ip_address]})
			else
				raise UserException.new("Device ID not exist for current user")
			end
		end
	end

	def index
		simple_json_response("Control Device") do
			RemoteDevice.where({remote_device_id: params[:device_id]}).first.user.ip_address
		end
	end
end