# == Schema Information
#
# Table name: breedappts
#
#  id             :bigint(8)        not null, primary key
#  dog_request_id :integer
#  dog_accept_id  :integer
#  status         :text
#  breeddate      :date
#  place          :text
#  image          :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Breedappt < ApplicationRecord
    belongs_to :woof, :optional => true


    public 
    def getPartnerDog (id, woof)
        partnerDog = nil
        if ( (id == woof.dog_request_id) || (id == woof.dog_request_id.to_s) )
            partnerDog = Dog.find woof.dog_accept_id
        end
        if ( (id == woof.dog_accept_id) || (id == woof.dog_accept_id.to_s) )
            partnerDog = Dog.find woof.dog_request_id
        end
#binding.pry
        return partnerDog
    end

    public 
    def getPartnerDogBreedAppt (id, breedappt)
        partnerDog = nil
        if ( (id == breedappt.dog_request_id) || (id == breedappt.dog_request_id.to_s) )
            partnerDog = Dog.find breedappt.dog_accept_id
        end
        if ( (id == breedappt.dog_accept_id) || (id == breedappt.dog_accept_id.to_s) )
            partnerDog = Dog.find breedappt.dog_request_id
        end
#binding.pry
        return partnerDog
    end


    public 
    def getWoofDogs (currentDog_id, woofid)
        currentDog = Dog.find currentDog_id
        #assume at this point the status is "Woof-up Expired"
#binding.pry
        woof = Woof.find woofid
        partnerDog = getPartnerDog currentDog_id, woof
        return {
            :currentDog => currentDog,
            :partnerDog => partnerDog
        }
    end


    public 
    def getBreedingDogs (id, breedappt)
        currentDog = Dog.find id
        partnerDog = nil
        if ( (id == breedappt.dog_request_id) || (id == breedappt.dog_request_id.to_s) )
            partnerDog = Dog.find breedappt.dog_accept_id
        end
        if ( (id == breedappt.dog_accept_id) || (id == breedappt.dog_accept_id.to_s) )
            partnerDog = Dog.find breedappt.dog_request_id
        end
#binding.pry
        return {
            :currentDog => currentDog,
            :partnerDog => partnerDog
        }
    end

    public 
    def setupBreedAppt params 
#binding.pry
        #Parameters {"breedappt"=>{"bdate"=>"2019-04-25", "place"=>"Sydney"}, 
        #"message_text"=>"Hi Chikadora, we've met before", "controller"=>"breedappts", "action"=>"setupbreedappt", "id"=>"26", "woofid"=>"13"}
        bdate = params[:breedappt][:bdate]
        bplace = params[:breedappt][:place]
        message_text = params[:message_text]
        currentDog = Dog.find params[:id]    
        woofid = params[:woofid]
        woof = Woof.find woofid
        partnerDog = getPartnerDog currentDog.id, woof

        bp = Breedappt.new
        bp.dog_request_id = currentDog.id
        bp.dog_accept_id = partnerDog.id
        bp.breeddate = bdate
        bp.place = bplace
        woof.breedappts << bp
        bp.save

        if message_text.present?
            message = Message.new
            message.sender_id = currentDog.id #initiator
            message.sender_name = currentDog.name
            message.message_text = message_text
            woof.messages << message
            message.save
        end

        newstatus = "Breeding Appointment Reminder"

        woof.update(:status => newstatus)
        currentDog.update(:status => newstatus)
        partnerDog.update(:status => newstatus)
    
    end



    public 
    def updateBreedappt (w, array)
        breedappt = w
        id = array[:id]
#binding.pry
        breedappt.update(:place => array[:breedappt][:place])
        breedappt.update(:breeddate => array[:breedappt][:breeddate])
        breedappt.update(:dog_request_id => id) #initiator
        woof = array[:woofid]
        partnerDog = getPartnerDogBreedAppt id, breedappt
        partnerDogId = partnerDog.id
        breedappt.update(:dog_accept_id => partnerDogId)

        #messages
#binding.pry
        message_text = array[:message_text]
        if message_text.present?
            woof = Woof.find breedappt.woof_id
            message = Message.new
            message.sender_id = id #initiator
            message.sender_name = message.getName id
            message.message_text = array[:message_text]
            woof.messages << message
            message.save
        end
    end

    public 
    def cancelBreedappt w
        breedappt = w
#binding.pry
        #status back to 
        newstatus = "Woof-up Expired"
        #dogs to same status
        d1 = Dog.find w.dog_request_id #initiator
        d2 = Dog.find w.dog_accept_id
        woof = Woof.find w.woof_id

        d1.update(:status => newstatus)
        d2.update(:status => newstatus)
        woof.update(:status => newstatus)

        breedappt.destroy
    end

end
