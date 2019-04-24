class MessagesController < ApplicationController

  def woofmessage
#binding.pry
    msg = Message.new
    @randomText = msg.getPickupLine
    if params[:id].present?
      @currDogId = params[:id]
    end
    if params[:woofid].present?
      @woofid = params[:woofid]
    end
    @name = msg.getName @currDogId    
#binding.pry
    @msgArray = Message.where(woof_id: @woofid)
#binding.pry
    images = msg.getDogImages params[:id], params[:woofid]
    @dogimage = images[:dogimage]
    @partnerDogimage = images[:partnerDogimage]
    @partnerDogname = images[:partnerDogname]
#binding.pry
  end

  def woofmessagesend
#binding.pry
    msg = Message.new
    #@randomText = msg.getPickupLine
    msg.saveMessage params[:woofid], params[:currentdogid], params[:message_text], params[:sender]
    @currDogId = params[:currentdogid]
    @woofid = params[:woofid]
#binding.pry
    redirect_to "/messages/#{@woofid}/#{@currDogId}/message"
  end



end
