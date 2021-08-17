module MyPortfolioHelper
    def nav_status(path_a, path_b)
        return 'active' if path_a == path_b
    end 
end
