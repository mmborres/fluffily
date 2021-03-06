class WoofsController < ApplicationController
  include WoofsHelper
  
  def match
    @request_id = params[:id]
    @woof = Woof.new
    @matches = @woof.getMatches @request_id 
    @dog = Dog.find @request_id
  #binding.pry
  end

  def changepref
    @request_id = params[:id]
    @dog = Dog.find @request_id
    @booleanMalepref_sex = ( @dog.pref_sex.upcase == "MALE" )
    @booleanFemalepref_sex = ( @dog.pref_sex.upcase == "FEMALE" )
    @breeds = getBreeds
    @colors = getColors
    @locations = getLocations
#binding.pry
  end

  def updatepref
#binding.pry
    @dog = Dog.find params[:id]
    @dog.update(:pref_sex => params[:dog][:pref_sex])
    @dog.update(:pref_breed => params[:dog][:pref_breed])
    @dog.update(:pref_color => params[:dog][:pref_color])
    @dog.update(:pref_location => params[:dog][:pref_location])

    redirect_to "/woofs/#{params[:id]}"
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
    #dog to show is params[:id2] --- #partner
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
    @currentDog_name = pageDetails[:currentDog_name]
    @partnerDog_name = pageDetails[:partnerDog_name]
    @partnerDog_img = pageDetails[:partnerDog_img]
    @currentDog_img = pageDetails[:currentDog_img]
    @woof_id = pageDetails[:woof_id]
    @currentStatus = pageDetails[:currentStatus]
    @woofupdateconfirmed = pageDetails[:woofupdateconfirmed]
    @woofupdate_when = pageDetails[:woofupdate_when]
    @woofupdate_where = pageDetails[:woofupdate_where]
    @breedappt_when = pageDetails[:breedappt_when]
    @breedappt_where = pageDetails[:breedappt_where]
    @breedapptconfirmed = pageDetails[:breedapptconfirmed]
    @walkdate_when = pageDetails[:walkdate_when]
    @walkdate_where = pageDetails[:walkdate_where]
    @walkdateconfirmed = pageDetails[:walkdateconfirmed]
    @checkEligibleBreedingAppt = pageDetails[:eligibleForBreedingAppt]
#binding.pry    
    render pageDetails[:pageToRender]
  end

end
