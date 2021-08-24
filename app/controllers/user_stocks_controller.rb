class UserStocksController < ApplicationController

	def create
		stock = Stock.check_db(params[:ticker])
		if stock.blank?
			client = Stock.conn()
			stock = Stock.new_lookup(client, params[:ticker])
			stock.save
		end
		@user_stock = UserStock.create(user: current_user, stock: stock)
		redirect_to my_portfolio_path, notice: "Stock #{ stock.name } was successfully added to your portfolio"
	end 

	def destroy
		stock = Stock.find(params[:id])
		user_stock = UserStock.where(user_id: current_user.id, stock_id: stock.id).first
		user_stock.destroy
		redirect_to my_portfolio_path, notice: "#{ stock.ticker } was removed successfully from portfolio"
	end

end
