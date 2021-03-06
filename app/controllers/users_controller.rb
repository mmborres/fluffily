class UsersController < ApplicationController
  before_action :check_for_admin, :only => [:index]

  def index
#binding.pry
    @users = User.all
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find params[:id]
#binding.pry
  end

  def update
    user = User.new
    id = params[:id]
    name = params[:user][:name]
    image = params[:user][:image]
    user.updateSpecific id, name, image
#binding.pry
    redirect_to root_path
  end


  def create
    #if params[:user][:email].blank?
    #  redirect_to error_path
    #end

    @user = User.new user_params
    if @user.save
      session[:user_id] = @user.id
      session[:newuser] = true
#binding.pry
      redirect_to root_path
    else
      render :new  
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :dob, :image)
  end
end
