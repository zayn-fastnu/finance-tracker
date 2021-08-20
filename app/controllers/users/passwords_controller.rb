class Users::PasswordsController < Devise::PasswordsController
    include ApplicationHelper
    
    def new
        @new_pass = true
        super
    end 

    def update
    end 
end
