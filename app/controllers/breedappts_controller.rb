class BreedapptsController < ApplicationController
  
  def breedappt
    @woof_id = params[:woofid]
    currentDog_id = params[:id]
    #assume at this point the status is "Woof-up Expired"
    bp = Breedappt.new
    coupledogs = bp.getWoofDogs currentDog_id, @woof_id
    @currentDog = coupledogs[:currentDog]
    @partnerDog = coupledogs[:partnerDog]
  end

  def setupbreedappt
binding.pry
    bp = Breedappt.new
    bp.setupBreedAppt params
    # new status "Breeding Appointment Reminder"
    redirect_to dogs_path
  end

  def reminder #from different route, take note
binding.pry
    redirect_to dogs_path
  end


  def edit
binding.pry
    @breedappt = Breedappt.find_by(woof_id: params[:woofid])
    @woof_id = params[:woofid]
    coupledogs = @breedappt.getBreedingDogs params[:id], @breedappt
    @currentDog = coupledogs[:currentDog]
    @partnerDog = coupledogs[:partnerDog]
#binding.pry
  end

  def update 
binding.pry
    breedappt = Breedappt.find_by(woof_id: params[:woofid])
    breedappt.updateBreedappt breedappt, params
#binding.pry
    redirect_to dogs_path
  end

  def cancel
    breedappt = Breedappt.find_by(woof_id: params[:woofid])
    breedappt.cancelBreedappt breedappt
#binding.pry
    redirect_to dogs_path
  end

  def confirm
    breedappt = Breedappt.find_by(woof_id: params[:woofid])
    breedappt.update(:status => "Confirmed")
#binding.pry
    redirect_to dogs_path
  end

end
