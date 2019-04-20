class WoofsController < ApplicationController
  
  def match
    @request_id = params[:id]
    @woof = Woof.new
    @matches = @woof.getMatches @request_id 
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
    @mydog = Dg.find @request_id
    #dog to show is params[:id2]
    @dog = Dog.find params[:id2]
    @owner_name = @dog.getOwnerName @dog.user_id
  end

  def create
#binding.pry
    woof = Woof.new
    woof.dog_request_id = params[:id]
    woof.dog_accept_id = params[:id2]
    woof.status = "Pending"
    woof.save
#binding.pry
    message = Message.new
    message.sender_id = params[:id]
    message.sender_name = message.getName message.sender_id
    message.message_text = params[:message_text]
binding.pry
    woof.messages << message
    message.save
#binding.pry
    woof.updateStatusCreate params[:id], params[:id2]
    redirect_to root_path
  end

  def status
    woof = Woof.new
    #use woof to get details
    @pageDetails = woof.getStatusPageDetails params[:id]
  end

end
