class Users::SessionsController < Devise::SessionsController
  before_action :set_search

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
    if params[:q].values.reject(&:blank?).any?
      @q = User.ransack(params[:q])
      friends =@q.result(distinct: true)
      unless friends.empty?
        @friends = friends.reject { |user| user.id == current_user.id }
        respond_to do |format|
          format.js { render partial: 'users/sessions/friend_result' }
        end
      else
        respond_to do |format|
          flash.now[:alert] = "No user found!"
          format.js { render partial: 'users/sessions/friend_result' }
        end
      end
    else
      respond_to do |format|
        flash.now[:alert] = "Please enter a friend's name or email to search"
        format.js { render partial: 'users/sessions/friend_result' }
      end
    end
  end

  def price_results(stocks)
    @tracked_stocks = stocks
    @user = current_user
    if @tracked_stocks
      respond_to do |format|
        flash.now[:notice] = "Stocks updated succesfully!"
        format.js {render partial: 'users/sessions/stocks/list' }
      end  
    else
      respond_to do |format|
        flash.now[:alert] = "Stocks can't be updated at the moment. Please try again!"
        format.js {render partial: 'users/sessions/stocks/list' }
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

  protected
    def set_search
      @q = User.ransack(params[:q])
      GoogleSearch.api_key = "ff2bccdbce4b28080da429282d777be0bd266be8e41a57f3e3be001b59255653"
    end

end
