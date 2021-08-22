# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  def new
    @new_user = true
    super
  end
  
  def my_portfolio
    @user = current_user
    @tracked_stocks = current_user.stocks
  end
  
  def my_friends
    @friends = current_user.friends
  end

  def show
    @user = User.find(params[:id])
    @tracked_stocks = @user.stocks
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

  def price_results(stocks)
    @tracked_stocks = stocks
    @user = current_user
    if @tracked_stocks
      respond_to do |format|
        flash.now[:notice] = "Stocks updated succesfully!"
        format.js {render partial: 'users/sessions/stocks/list'}
      end  
    else
      respond_to do |format|
        flash.now[:alert] = "Stocks can't be updated at the moment. Please try again!"
        format.js {render partial: 'users/sessions/stocks/list'}
      end
      
    end
  end

  def refresh
    price_results(Stock.update_stocks(current_user.stocks))
  end

  def order_up
    price_results(Stock.sort_up(current_user.stocks))
  end 

  def order_down
    price_results(Stock.sort_down(current_user.stocks))
  end 

  def web_search
    
    @search = GoogleSearch.new({
      q: params[:query], # search search
      tbm: "nws", # news
      tbs: "qdr:d", # last 24h
      num: 10
    })
    
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
