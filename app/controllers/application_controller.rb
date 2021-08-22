class ApplicationController < ActionController::Base
    before_action :authenticate_user!   
    before_action :set_search
    
    

    protected
    
    def set_search
        @q = User.ransack(params[:q])
        GoogleSearch.api_key = "ff2bccdbce4b28080da429282d777be0bd266be8e41a57f3e3be001b59255653"
    end

    
end
