class Api::V1::SessionsController < Devise::SessionsController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }

  skip_before_filter :authenticate_user_from_token!, only: [:create, :failure]
  skip_before_filter :verify_signed_out_user, only: :destroy

  respond_to :json

  def create
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
    render :status => 401,
           :json => { :success => false,
                      :info => "Login Failed",
                      :data => {} }
  end

  protected

    def auth_options
      { scope: resource_name, recall: "#{controller_path}#failure" }
    end
end