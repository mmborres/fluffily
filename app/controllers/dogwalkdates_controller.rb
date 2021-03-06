class DogwalkdatesController < ApplicationController
  
  def dogwalkdate
#binding.pry
    @woof_id = params[:woofid]
    currentDog_id = params[:id]

    bp = Dogwalkdate.new
    coupledogs = bp.getWoofDogs currentDog_id, @woof_id
    @currentDog = coupledogs[:currentDog]
    @partnerDog = coupledogs[:partnerDog]
  end

  def setupdogwalkdate
#binding.pry
    bp = Dogwalkdate.new
    bp.setupDogwalkdate params

    redirect_to dogs_path
  end
    
  def reminder #from different route, take note
    #binding.pry
    redirect_to dogs_path
  end

  def edit
#binding.pry
        @woof_id = params[:woofid]
        @dogwalkdate = Dogwalkdate.where(woof_id: @woof_id).where(status: [nil, ""]).first #Dogwalkdate.find_by(woof_id: params[:woofid])
#binding.pry        
        coupledogs = @dogwalkdate.getWalkingDogs params[:id], @dogwalkdate
        @currentDog = coupledogs[:currentDog]
        @partnerDog = coupledogs[:partnerDog]
    #binding.pry
      end
    
      def update 
        @woof_id = params[:woofid]
#binding.pry
        dogwalkdate = Dogwalkdate.where(woof_id: @woof_id).where(status: [nil, ""]).first #Dogwalkdate.find_by(woof_id: params[:woofid])
        dogwalkdate.updateDogwalkdate dogwalkdate, params
    #binding.pry
        redirect_to dogs_path
      end
    
      def cancel
        dogwalkdate = Dogwalkdate.where(woof_id: params[:woofid]).where(status: [nil, ""]).first #Dogwalkdate.find_by(woof_id: params[:woofid])
        dogwalkdate.cancelDogwalkdate dogwalkdate
    #binding.pry
        redirect_to dogs_path
      end
    
      def confirm
        dogwalkdate = Dogwalkdate.where(woof_id: params[:woofid]).where(status: [nil, ""]).first #Dogwalkdate.find_by(woof_id: params[:woofid])
        dogwalkdate.update(:status => "Confirmed")
    #binding.pry
        redirect_to dogs_path
      end
    



###################################################

  def breakup
#binding.pry
    @woofid = params[:woofid]
    #get dogs details
    #page is rules for breakup
    bp = Dogwalkdate.new
    coupledogs = bp.getWoofDogs params[:id], @woofid
    @currentDog = coupledogs[:currentDog]
    @partnerDog = coupledogs[:partnerDog]
  end

  def breakupconfirm
#binding.pry
    woofid = params[:woofid]
    dw = Dogwalkdate.new
    dw.processBreakup woofid
    #woof id
    #woof status set to breakup
    #status both dogs set to Available
    #delete woofupdates
    #delete dogwalkdates
    #do not delete breedappts
    redirect_to dogs_path
  end
end
