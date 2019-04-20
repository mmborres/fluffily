class ApplicationController < ActionController::Base
    before_action :fetch_user
    after_action :update_session

    private
    def fetch_user
        @current_user = User.find_by :id => session[:user_id] if session[:user_id].present?
        session[:user_id] = nil unless @current_user.present?
#binding.pry
    end

    def update_session
#binding.pry
    end

    def check_for_login
#binding.pry
        redirect_to login_path unless @current_user.present?
    end

    def check_for_admin
#binding.pry
        redirect_to login_path unless (@current_user.present? && @current_user.admin?)
    end


end
