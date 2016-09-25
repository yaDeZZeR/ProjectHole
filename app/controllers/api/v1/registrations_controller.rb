class Api::V1::RegistrationsController < Devise::RegistrationsController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }

  skip_before_filter :authenticate_user_from_token!
  skip_before_filter :require_no_authentication, only: [:create]

  respond_to :json

  # Регистрация.
  # Передается токен устройства и платформа (android или ios)
  def create
    modification_json_response("Registered", "Not registered",
        [:id, :device_token, :platform, :authentication_token]) do

      user_params = sign_up_params
      User.new_from_device_info(user_params[:device_token], 
                                user_params[:platform], 
                                user_params[:login],
                                user_params[:password])
    end
  end

  private

    def sign_up_params
      params.require(:user).permit(:device_token, :platform, :login, :password)
    end
end
