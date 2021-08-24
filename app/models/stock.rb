class Stock < ApplicationRecord
	has_many :user_stocks
	has_many :users, through: :user_stocks

	validates :name, :ticker, presence: true

	def self.conn()
		client = IEX::Api::Client.new(
							publishable_token: "Tpk_5061f0b8cfbb4f5cad9427bfd5a26dad", 
							secret_token:"Tsk_ea83c24d59ff49818432b8c65273d605",
							endpoint: 'https://sandbox.iexapis.com/v1'
						)
	end

	def self.new_lookup(client, ticker_symbol)
		ticker_symbol.upcase!
		begin    
			new(ticker: ticker_symbol, name: client.company(ticker_symbol).company_name,last_price: client.price(ticker_symbol))
		rescue => exception
			return nil
		end
	end

	def self.check_db(ticker_symbol)
		where(ticker: ticker_symbol).first
	end 

	def self.update_stocks(current_stocks)
		client = conn()
		current_stocks.each do |f|
			res = new_lookup(client, f.ticker)
			f.last_price = res.last_price
			f.save
		end 
		current_stocks
	end
	
	def self.sort_up(current_stocks)
		current_stocks.order( "last_price DESC" )
	end 

	def self.sort_down(current_stocks)
		current_stocks.order( "last_price ASC" )
	end 
	
end
