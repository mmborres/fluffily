class WoofsController < ApplicationController
  
  def match
    @request_id = params[:id]
    @woof = Woof.new
    @matches = @woof.getMatches @request_id 
    @dog = Dog.find @request_id
  #binding.pry
  end

  def show
    @request_id = params[:id]
    #dog to show is params[:id2]
    @dog = Dog.find params[:id2]
  end

  def requestpage
#binding.pry
    @request_id = params[:id]
    @mydog = Dog.find @request_id
    #dog to show is params[:id2]
    @dog = Dog.find params[:id2]
    @owner_name = @dog.getOwnerName @dog.user_id
  end

  def create
    woof = Woof.new
    woof.createInitialWoof params[:id], params[:id2], params[:message_text]
    redirect_to dogs_path
  end

  def status
    woof = Woof.new
    #use woof to get details
    @initiator_dogid = params[:id]
    pageDetails = woof.getStatusPageDetails @initiator_dogid

    @heading = pageDetails[:heading]
    @subheading = pageDetails[:subheading]
    @msgArray = pageDetails[:msgArray]
    @partnerDog_id = pageDetails[:partnerDog_id]
    @currentDog_id = @initiator_dogid
    @partnerDog_img = pageDetails[:partnerDog_img]
    @woof_id = pageDetails[:woof_id]
    @currentStatus = pageDetails[:currentStatus]
    @woofupdateconfirmed = pageDetails[:woofupdateconfirmed]
    @woofupdate_when = pageDetails[:woofupdate_when]
    @woofupdate_where = pageDetails[:woofupdate_where]
binding.pry    
    render pageDetails[:pageToRender]
  end

end
