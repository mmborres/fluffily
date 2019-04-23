class WoofupdatesController < ApplicationController
  
  def woofupdate
#everything is passes
  end

  def woof  
    #approve
    wuf = Woofupdate.new
    wuf.processApprove params[:woofid]
    #show set woofup
    #@woofupdate = Woofupdate.new
    @currentDog_id = params[:id]
    @woof_id = params[:woofid]
  end

  def edit 
    @woofupdate = Woofupdate.find_by(woof_id: params[:woofid])
    @currentDog_id = params[:id]
    @woof_id = params[:woofid]
#binding.pry
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
