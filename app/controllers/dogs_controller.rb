class DogsController < ApplicationController
  before_action :check_for_login, :only => [:new, :create, :show, :index, :edit, :update]
  #before_action :check_for_admin, :only => [:index]

  def index
    if @current_user.admin?
      @alldogs = Dog.all
    end

    @mydogs = @current_user.dogs 
  end

  def new
    @dog = Dog.new
    #pre-select
    @booleanMale = true
    @booleanFemalepref_sex = true
  end

  def show
    @showmatches = true
    @dog = Dog.find params[:id]
    if @dog.status.present?
      if @dog.status != "Available"
        @showmatches = false
      end
    end
  end

  def create
    dog = Dog.create dog_params
    dog.status = "Available"
    @current_user.dogs << dog
#binding.pry
    redirect_to dogs_path
  end

  def edit
    @dog = Dog.find params[:id]
    @booleanMale = ( @dog.sex.upcase == "MALE" )
    @booleanFemale = ( @dog.sex.upcase == "FEMALE" )
    @booleanMalepref_sex = ( @dog.pref_sex.upcase == "MALE" )
    @booleanFemalepref_sex = ( @dog.pref_sex.upcase == "FEMALE" )
#binding.pry
  end

  def update
    dog = Dog.find params[:id]
    dog.update dog_params
    redirect_to dog_path(dog.id)
  end

  def destroy
    dog = Dog.find params[:id]
    dog.destroy
    redirect_to dogs_path
  end

  private
  def dog_params
    params.require(:dog).permit(:name, :dob, :sex, :breed, :color, :image, :location, :pref_sex, :pref_breed, :pref_color, :pref_location)
  end
end
