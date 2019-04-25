class WoofupdatesController < ApplicationController
  
  def woofupdate
#everything is passed
  end

  def woof  
    #approve
    wuf = Woofupdate.new
    wuf.processApprove params[:woofid]
    #show set woofup
    @currentDog_id = params[:id]
    @woof_id = params[:woofid]
    woof = Woof.find @woof_id
    @currentDog_img = wuf.getDogImage @currentDog_id
    @currentDog_name = wuf.getDogName @currentDog_id
    partnerId = wuf.getWoofUpPartnerDogId @currentDog_id, woof
    @partnerDog_img = wuf.getDogImage partnerId
    @partnerDog_name = wuf.getDogName partnerId
  end

  def edit 
    @woofupdate = Woofupdate.find_by(woof_id: params[:woofid])
    @currentDog_id = params[:id]
    @woof_id = params[:woofid]
binding.pry
    woof = Woof.find @woof_id
    @currentDog_img = @woofupdate.getDogImage @currentDog_id
    @currentDog_name = @woofupdate.getDogName @currentDog_id
    partnerId = @woofupdate.getWoofUpPartnerDogId @currentDog_id, woof
    @partnerDog_img = @woofupdate.getDogImage partnerId
    @partnerDog_name = @woofupdate.getDogName partnerId
  end

  def update 
    woofupdate = Woofupdate.find_by(woof_id: params[:woofid])
    woofupdate.updateWoofUp woofupdate, params
#binding.pry
    redirect_to dogs_path
  end

  def cancel
    woofupdate = Woofupdate.find_by(woof_id: params[:woofid])
    woofupdate.cancelWoofUp woofupdate
#binding.pry
    redirect_to dogs_path
  end

  def confirm
    woofupdate = Woofupdate.find_by(woof_id: params[:woofid])
    woofupdate.update(:status => "Confirmed")
#binding.pry
    redirect_to dogs_path
  end

  def setupwoofup #from different route, take note
#binding.pry
    woofupdate = Woofupdate.create woofupdate_params
    woofupdate.update(:woof_id => params[:woofid])
    woofupdate.update(:dog_request_id => params[:id]) #initiator
    woofupdate = woofupdate.setupwoofup woofupdate #the other attributes
    redirect_to dogs_path
  end

  def withdraw
    woofupdate = Woofupdate.new
    woofupdate.processWithdraw params[:woofid]
    redirect_to dogs_path
  end

  private
  def woofupdate_params
    params.require(:woofupdate).permit(:woofid, :place, :woofdate)
  end
end
