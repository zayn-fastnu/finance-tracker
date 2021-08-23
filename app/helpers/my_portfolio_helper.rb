module MyPortfolioHelper
    def nav_status(path)
        return 'active' if path == my_portfolio_path
    end 
end
