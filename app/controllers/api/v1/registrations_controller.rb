class Api::V1::RegistrationsController < Api::V1::BaseController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }

  skip_before_filter :authenticate_user_from_token!

  before_filter :check_api_key

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

  def email
    simple_json_response("Email registration") do 
      par = {login: sign_up_email_params[:email], password: sign_up_email_params[:password]}
      info = {}
       user = User.where({login: par[:login]}).first
       not_user = NotConfirmedUser.where({login: par[:login]}).first
       if user.nil? && not_user.nil?
         token = NotConfirmedUser.generate_token
         not_conf_user = NotConfirmedUser.create(par.merge({token: token}))
         SendEmailWorker.perform_async(par[:login], not_conf_user.id, token)
         info[:status] = "send_email"
       elsif !not_user.nil?
         info[:status] = "user_not_confirmed"
       else
         info[:status] = "email_confirmed"
       end
       info
    end
  end

  private

    def sign_up_params
      params.require(:user).permit(:device_token, :platform, :login, :password)
    end

    def sign_up_email_params
      params.permit(:email, :password)
    end

    def check_api_key
      if params[:api_key] != ENV["API_KEY"]
        simple_json_response("Not registered") do
          raise UserException.new("Invalid API_KEY")
        end
      end
    end
end
