class Stock < ApplicationRecord
    has_many :user_stocks
    has_many :users, through: :user_stocks
    validates :name, :ticker, presence: true
    def self.new_lookup(ticker_symbol)
        ticker_symbol.upcase!
        client = IEX::Api::Client.new(
            publishable_token: "Tpk_5061f0b8cfbb4f5cad9427bfd5a26dad", 
            secret_token:"Tsk_ea83c24d59ff49818432b8c65273d605",
            endpoint: 'https://sandbox.iexapis.com/v1')
        begin    
            new(ticker: ticker_symbol, name: client.company(ticker_symbol).company_name,last_price: client.price(ticker_symbol))
        rescue => exception
            return nil
        end
    end

    def self.check_db(ticker_symbol)
        where(ticker: ticker_symbol).first
    end 

end
