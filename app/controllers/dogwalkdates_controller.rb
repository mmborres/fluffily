class DogwalkdatesController < ApplicationController
  
  def dogwalkdate
  end


  def breakup
binding.pry
    @woofid = params[:woofid]
    #get dogs details
    #page is rules for breakup
  end

  def breakupconfirm
binding.pry
    woofid = params[:woofid]
    dw = Dogwalkdate.new
    dw.processBreakup woofid
    #woof id
    #woof status set to breakup
    #status both dogs set to Available
    #delete woofupdates
    #delete dogwalkdates
    #do not delete breedappts
    redirect_to dogs path
  end
end
