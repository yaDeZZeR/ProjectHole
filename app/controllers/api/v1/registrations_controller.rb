class Api::V1::RegistrationsController < Devise::RegistrationsController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }

  skip_before_filter :authenticate_user_from_token!

  respond_to :json

  def create
    build_resource(sign_up_params)

    if resource.save
      sign_in resource
      render :status => 200,
           :json => { :success => true,
                      :info => "Registered",
                      :data => { :user => resource } }
    else
      render :status => :unprocessable_entity,
             :json => { :success => false,
                        :info => resource.errors,
                        :data => {} }
    end
  end

  private

    def sign_up_params
      devise_parameter_sanitizer.sanitize(:sign_up)
    end
end
