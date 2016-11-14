class Api::V1::SessionsController < Devise::SessionsController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }

  before_filter :authenticate_user_from_token!, only: [:destroy]

  skip_before_filter :require_no_authentication, only: [:create, :failure]
  skip_before_filter :verify_signed_out_user, only: :destroy

  respond_to :json

  def create
    last_user = current_user
    if last_user
      sign_out(last_user)
    end

    warden.authenticate!(auth_options)
    user = current_user
    user.ensure_authentication_token
    user.save
    render :status => 200,
         :json => { :success => true,
                    :info => "Logged in",
                    :data => { :auth_token => user.authentication_token } }
  end

  def destroy
    current_user.update_column(:authentication_token, nil)
    render :status => 200,
           :json => { :success => true,
                      :info => "Logged out",
                      :data => {} }
  end

  def failure
    puts 'aaaaaaaaaaaaaa'
    render :status => 401,
           :json => { :success => false,
                      :info => "Login Failed",
                      :data => {} }
  end

  def gcm_params
      params.require(:user).permit(:gcm_token)
  end

  protected

    def auth_options
      puts resource_name
      { scope: resource_name, recall: "#{controller_path}#failure" }
    end
end