# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  
  def my_portfolio
    @tracked_stocks = current_user.stocks
  end
  
  def my_friends
    @friends = current_user.friends
  end

  def search
    if User.params_allowed?(params)
      @friends = current_user.find_friends(params)
        unless @friends == nil
          respond_to do |format|
          format.js { render partial: 'users/sessions/friend_result'}
          end
        else
          respond_to do |format|
            flash.now[:alert] = "No user found!"
            format.js { render partial: 'users/sessions/friend_result'}
          end
        end
    else
      respond_to do |format|
        flash.now[:alert] = "Please enter a friend's name or email to search"
        format.js { render partial: 'users/sessions/friend_result'}
      end
    end
  end

  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
