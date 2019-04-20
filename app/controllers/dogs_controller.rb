class DogsController < ApplicationController
  before_action :check_for_login, :only => [:new, :create, :show, :index, :edit, :update]
  #before_action :check_for_admin, :only => [:index]

  def index
#binding.pry
    if @current_user.admin?
      @alldogs = Dog.all
    end

    @mydogs = @current_user.dogs 
binding.pry
  end

  def new
    @dog = Dog.new
    @dog.setbool
    @booleanMale = true
    @booleanFemalepref_sex = true
binding.pry
  end

  def show
#binding.pry
    @showmatches = true
    @dog = Dog.find params[:id]
    if @dog.status.present?
      if @dog.status != "Available"
        @showmatches = false
      end
    end
binding.pry
  end

  def create
#binding.pry
    dog = Dog.create dog_params
    dog.status = "Available"
    @current_user.dogs << dog
    dog.save
    redirect_to dogs_path
  end

  def edit
    @dog = Dog.find params[:id]
#binding.pry
    @dog.setbool

    if @dog.sex.present?
      @booleanMale = (@dog.sex.upcase == "MALE")
      @booleanFemale = (@dog.sex.upcase == "FEMALE")
      if ( (@booleanMale == false) && (@booleanFemale == false) )
        #preselect Male
        @booleanMale = true
      end
    else
      #preselect Male
      @booleanMale = true
    end
    if @dog.pref_sex.present?
      @booleanMalepref_sex = (@dog.pref_sex.upcase == "MALE")
      @booleanFemalepref_sex = (@dog.pref_sex.upcase == "FEMALE")
      if ( (@booleanMalepref_sex == false) && (@booleanFemalepref_sex == false) && (@booleanMale == true) )
        #preselect Female
        @booleanFemalepref_sex = true
      end
    else
      #preselect Female
      @booleanFemalepref_sex = true
    end
  end

  def update
    dog = Dog.find params[:id]
    dog.update dog_params
binding.pry
    redirect_to dog_path(dog.id)
  end

  def destroy
    dog = Dog.find params[:id]
    dog.destroy
    if @current_user.dogs.size > 0
      redirect_to dogs_path
    else
      redirect_to root_path
    end
  end

  private
  def dog_params
    params.require(:dog).permit(:name, :dob, :sex, :breed, :color, :image, :location, :pref_sex, :pref_breed, :pref_color, :pref_location)
  end
end
