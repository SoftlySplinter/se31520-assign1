class ApplicationController < ActionController::Base
    helper :all # include all helpers, all the time
    helper_method :is_admin?
    protect_from_forgery 
    
    protected
    
    def is_admin?
        true
    end
end
