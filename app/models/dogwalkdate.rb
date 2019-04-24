# == Schema Information
#
# Table name: dogwalkdates
#
#  id             :bigint(8)        not null, primary key
#  dog_request_id :integer
#  dog_accept_id  :integer
#  status         :text
#  walkdate       :date
#  place          :text
#  image          :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Dogwalkdate < ApplicationRecord
    belongs_to :woof, :optional => true

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
    def processBreakup woofid
        #woof id
        #woof status set to breakup
        #status both dogs set to Available
        #delete woofupdates
        #delete dogwalkdates
        #do not delete breedappts
        
        woof = Woof.find woofid
        woof.update(:status => "Breakup")

        d1 = Dog.find woof.dog_request_id
        d2 = Dog.find woof.dog_accept_id
        d1.update(:status => "Available")
        d2.update(:status => "Available")

        woofupdate = Woofupdate.find_by(woof_id: woofid)
        if woofupdate != nil
            woofupdate.destroy
        end

        dogwalkdate = Dogwalkdate.find_by(woof_id: woofid)
        if dogwalkdate != nil
            dogwalkdate.destroy
        end
    end

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
    def setupDogwalkdate params 
#binding.pry
        #Parameters {"breedappt"=>{"bdate"=>"2019-04-25", "place"=>"Sydney"}, 
        #"message_text"=>"Hi Chikadora, we've met before", "controller"=>"breedappts", "action"=>"setupbreedappt", "id"=>"26", "woofid"=>"13"}
        bdate = params[:dogwalkdate][:bdate]
        bplace = params[:dogwalkdate][:place]
        message_text = params[:message_text]
        currentDog = Dog.find params[:id]    
        woofid = params[:woofid]
        woof = Woof.find woofid
        partnerDog = getPartnerDog currentDog.id, woof

        bp = Dogwalkdate.new
        bp.dog_request_id = currentDog.id
        bp.dog_accept_id = partnerDog.id
        bp.walkdate = bdate
        bp.place = bplace
        woof.dogwalkdates << bp
        bp.save

        if message_text.present?
            message = Message.new
            message.sender_id = currentDog.id #initiator
            message.sender_name = currentDog.name
            message.message_text = message_text
            woof.messages << message
            message.save
        end

        newstatus = "Dogwalk Date Reminder"

        woof.update(:status => newstatus)
        currentDog.update(:status => newstatus)
        partnerDog.update(:status => newstatus)
    
    end

    public 
    def getPartnerDogWalkdate (id, dogwalkdate)
        partnerDog = nil
        if ( (id == dogwalkdate.dog_request_id) || (id == dogwalkdate.dog_request_id.to_s) )
            partnerDog = Dog.find dogwalkdate.dog_accept_id
        end
        if ( (id == dogwalkdate.dog_accept_id) || (id == dogwalkdate.dog_accept_id.to_s) )
            partnerDog = Dog.find dogwalkdate.dog_request_id
        end
#binding.pry
        return partnerDog
    end

    public 
    def updateDogwalkdate (w, array)
        dogwalkdate = w
        id = array[:id]
#binding.pry
        dogwalkdate.update(:place => array[:dogwalkdate][:place])
        dogwalkdate.update(:walkdate => array[:dogwalkdate][:bdate])
        dogwalkdate.update(:dog_request_id => id) #initiator
        woof = array[:woofid]
        partnerDog = getPartnerDogWalkdate id, dogwalkdate
        partnerDogId = partnerDog.id
        dogwalkdate.update(:dog_accept_id => partnerDogId)

        #messages
#binding.pry
        message_text = array[:message_text]
        if message_text.present?
            woof = Woof.find dogwalkdate.woof_id
            message = Message.new
            message.sender_id = id #initiator
            message.sender_name = message.getName id
            message.message_text = array[:message_text]
            woof.messages << message
            message.save
        end
    end

    public 
    def cancelDogwalkdate w
        dogwalkdate = w
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

        dogwalkdate.destroy
    end


    public 
    def getWalkingDogs (id, dogwalkdate)
        currentDog = Dog.find id
        partnerDog = nil
        if ( (id == dogwalkdate.dog_request_id) || (id == dogwalkdate.dog_request_id.to_s) )
            partnerDog = Dog.find dogwalkdate.dog_accept_id
        end
        if ( (id == dogwalkdate.dog_accept_id) || (id == dogwalkdate.dog_accept_id.to_s) )
            partnerDog = Dog.find dogwalkdate.dog_request_id
        end
#binding.pry
        return {
            :currentDog => currentDog,
            :partnerDog => partnerDog
        }
    end

end
