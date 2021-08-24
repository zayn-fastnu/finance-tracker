class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  def new
    @sign_up = true
    super
  end

  protected
    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute,:first_name,:last_name])
    end

    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update, keys: [:attribute,:first_name,:last_name])
    end
end
