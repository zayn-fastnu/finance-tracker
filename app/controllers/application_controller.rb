class ApplicationController < ActionController::Base
    before_action :authenticate_user!   
    before_action :set_search
    

    protected
    
    def set_search
        @q = User.ransack(params[:q])
    end

    
end
