class SessionController < ApplicationController
  def new
  end

  def create
    # find the user
    user = User.find_by :email => params[:email]
    if user.present? && user.authenticate(params[:password])
      session[:user_id] = user.id
      session[:newuser] = false
      redirect_to root_path
    else
      flash[:error] = "Invalid email or password"
      redirect_to login_path # Send them back to try again.
    end
    # if the user can be authenticated
    # redirect to home
    # else redirect to login
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path
  end
end
