# == Schema Information
#
# Table name: woofupdates
#
#  id             :bigint(8)        not null, primary key
#  dog_request_id :integer
#  dog_accept_id  :integer
#  status         :text
#  woofdate       :date
#  place          :text
#  image          :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Woofupdate < ApplicationRecord
    belongs_to :woof, :optional => true

    public
    def getDogImage id 
        dog = Dog.find id
        return dog.image
    end

    public
    def processWithdraw woofid 
#binding.pry
        #woof is cancelled
        woof = Woof.find woofid

        #dogs are available again
        d1 = Dog.find woof.dog_request_id
        d2 = Dog.find woof.dog_accept_id

        woof.update(:status => "Cancelled")
        d1.update(:status => "Available")
        d2.update(:status => "Available")
    end

    public 
    def processApprove woofid 
#binding.pry
        #woof progresses
        woof = Woof.find woofid
        newstatus = "Set Woof-up"

        #dogs to same status
        d1 = Dog.find woof.dog_request_id
        d2 = Dog.find woof.dog_accept_id

        woof.update(:status => newstatus)
        d1.update(:status => newstatus)
        d2.update(:status => newstatus)

       return woof
    end

    public 
    def setupwoofup woofupdateObj
        w = woofupdateObj
#binding.pry
        newstatus = "Woof-up Reminder"

        #woof progresses
        woof = Woof.find w.woof_id
        
        if woof.dog_request_id == w.dog_request_id
            w.update(:dog_accept_id => woof.dog_accept_id)
        else
            w.update(:dog_accept_id => woof.dog_request_id)
        end

        #dogs to same status
        d1 = Dog.find w.dog_request_id #initiator
        d2 = Dog.find w.dog_accept_id

        woof.update(:status => newstatus)
        d1.update(:status => newstatus)
        d2.update(:status => newstatus)
#binding.pry
        return w;
    end

    public 
    def updateWoofUp (w, array)
        woofupdate = w
        id = array[:id]
#binding.pry
        woofupdate.update(:place => array[:woofupdate][:place])
        woofupdate.update(:woofdate => array[:woofupdate][:woofdate])
        woofupdate.update(:dog_request_id => id) #initiator
        partnerDogId = getWoofUpPartnerDogId id, woofupdate
        woofupdate.update(:dog_accept_id => partnerDogId)
    end

    public 
    def cancelWoofUp w
        woofupdate = w
binding.pry
        #status back to 
        newstatus = "Set Woof-up"
        #dogs to same status
        d1 = Dog.find w.dog_request_id #initiator
        d2 = Dog.find w.dog_accept_id
        woof = Woof.find w.woof_id

        d1.update(:status => newstatus)
        d2.update(:status => newstatus)
        woof.update(:status => newstatus)

        woofupdate.destroy
    end


    public 
    def getWoofUpPartnerDogId (id, wuf)
        partnerDogId = 0
        if id == wuf.dog_accept_id
            partnerDogId = wuf.dog_request_id
        else
            partnerDogId = wuf.dog_accept_id
        end
        return partnerDogId
    end
end
