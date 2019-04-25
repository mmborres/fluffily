# == Schema Information
#
# Table name: woofs
#
#  id             :bigint(8)        not null, primary key
#  dog_request_id :integer
#  dog_accept_id  :integer
#  status         :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Woof < ApplicationRecord
    has_many :messages
    has_many :dogwalkdates
    has_many :breedappts
    has_many :woofupdates

    public
    def getMatches requestor_id
    #get the dog first
    dog = Dog.find requestor_id
    #ExecuteSql.run "SELECT * FROM dogs WHERE id=#{requestor_id}", mode: :raw
    #get the dog's preferences
    pref_sex = dog.pref_sex #dog[0][12]
    pref_breed = dog.pref_breed #dog[0][13]
    pref_color = dog.pref_color #dog[0][14]
    pref_location = dog.pref_location #dog[0][15]
#binding.pry
    selectstatement = "SELECT * FROM dogs WHERE id<>#{requestor_id} AND user_id<>#{dog.user_id} AND upper(sex)='#{pref_sex.upcase}' "

    if ( !(pref_breed.upcase.include? "ANY") && !(pref_breed.empty?) )
        selectstatement += "AND upper(breed)='#{pref_breed.upcase}' "
    end
    if ( !(pref_color.upcase.include? "ANY") && !(pref_color.empty?) )
        selectstatement += "AND upper(color)='#{pref_color.upcase}' "
    end
    if ( !(pref_location.upcase.include? "ANY") && !(pref_location.empty?) )
        selectstatement += "AND upper(location)='#{pref_location.upcase}' "
    end
#binding.pry
    matchedIDs = ExecuteSql.run selectstatement, mode: :raw
#binding.pry
    matchedDogs = []
    #loop through each matched ID
    if matchedIDs.length > 0
        i = 0;
        until i == matchedIDs.length
#binding.pry
            id = matchedIDs[i][0]
            tempDog = Dog.find id

            if ( tempDog.status == "Available" && (
                (tempDog.pref_sex.upcase == dog.sex.upcase) || (tempDog.pref_sex.upcase.include? "ANY") ||
                (tempDog.pref_breed.upcase == dog.breed.upcase) || (tempDog.pref_breed.upcase.include? "ANY") ||
                (tempDog.pref_color.upcase == dog.color.upcase) || (tempDog.pref_color.upcase.include? "ANY") ||
                (tempDog.pref_location.upcase == dog.location.upcase) || (tempDog.pref_color.location.include? "ANY")
            ) )
                matchedDogs.append tempDog
            end
#binding.pry
            i += 1;
        end
    end
#binding.pry    
    return matchedDogs
    end

    public
    def getRecentMessages messages
        if messages.length < 4
            messageArray = messages
            return messageArray.reverse
        end
#binding.pry
        last = messages.length-1
        beforelast = last-2
        messageArray = messages[beforelast..last].reverse
#binding.pry
        return messageArray
    end


    public 
    def createInitialWoof (request_id, accept_id, messageText)
        woof = Woof.new
        woof.dog_request_id = request_id
        woof.dog_accept_id = accept_id
        woof.status = "Pending"
#binding.pry
        woof.save
#binding.pry
        message = Message.new
        message.sender_id = request_id #initiator
        message.sender_name = message.getName message.sender_id
        message.message_text = messageText
        woof.messages << message
        message.save
#binding.pry
        woof.updateStatusCreate request_id, accept_id
    end

    public
    def updateStatusCreate (request_id, accept_id)
#binding.pry
        request_dog = Dog.find request_id
        accept_dog = Dog.find accept_id

        request_dog.update(:status => "Woof-up Request Sent")
        accept_dog.update(:status => "Woof-up Pending Approval")
    end

    public
    def updateStatusWoofupExpired wuf
        #set to "Woof-up Expired"
        request_dog = Dog.find wuf.dog_request_id
        accept_dog = Dog.find wuf.dog_accept_id

        request_dog.update(:status => "Woof-up Expired")
        accept_dog.update(:status => "Woof-up Expired")
    end

    public
    def updateStatusPostWoofExpired (wuf, newstatus)
        wuf.update(:status => newstatus)
        request_dog = Dog.find wuf.dog_request_id
        accept_dog = Dog.find wuf.dog_accept_id

        request_dog.update(:status => newstatus)
        accept_dog.update(:status => newstatus)
    end


    public 
    def getWoof (id, currstatus)
#binding.pry
        id = id.to_i
        wuf = Woof.find_by(dog_accept_id: id, status: currstatus)
#binding.pry
        if ( (wuf == nil) || (wuf == "") )
            wuf = Woof.find_by(dog_request_id: id, status: currstatus)
        end
#binding.pry
        return wuf
    end


    public 
    def getWoofupdate id
        wuf = Woofupdate.find_by(woof_id: id)
        return wuf
    end

    public 
    def getWoofPartnerDog (id, wuf)
#binding.pry
        partnerDog = nil
        if ( (id == wuf.dog_accept_id) || (id == wuf.dog_accept_id.to_s) )
            partnerDog = Dog.find wuf.dog_request_id
        else
            partnerDog = Dog.find wuf.dog_accept_id
        end
#binding.pry
        return partnerDog
    end

    public
    def getDogImage id 
        dog = Dog.find id
        return dog.image
    end

    public 
    def getDogName id 
        dog = Dog.find id
        return dog.name
    end

    public
    def hasBreedingAppt (id1, id2)
        hasbp = false
        #dog_request_id | dog_accept_id |  status
        bp = Breedappt.find_by(dog_request_id: id1, dog_accept_id: id2)
        if bp == nil
            bp = Breedappt.find_by(dog_request_id: id2, dog_accept_id: id1)
        end
#binding.pry
        if (bp != nil) 
            hasbp = true
        end
        return hasbp
    end

    public
    def checkEligibleBreedingAppt (id1, id2)
        #dog_request_id | dog_accept_id |  status
        bp = Breedappt.find_by(dog_request_id: id1, dog_accept_id: id2)
        if bp == nil
            bp = Breedappt.find_by(dog_request_id: id2, dog_accept_id: id1)
        end
#binding.pry
        if (bp != nil) && (bp.status != nil) && (bp.status.upcase == "CONFIRMED")
binding.pry
            oneyearafterbreed = bp.breeddate >> 12
            if (DateTime.now.to_date < oneyearafterbreed) 
                return false
            end
        end
        return true
    end


    public
    def getStatusPageDetails id
        dog = Dog.find id
        currstatus = dog.status
        wuf = nil
        messageArray = [] #last 2 messages if there are
        pageTitle = ""
        caption = ""
        partnerDog_id = 0
        woofupdateconfirmed = false
        breedapptconfirmed = false
        walkdateconfirmed = false
        eligibleForBreedingAppt = true

        #Find Woof-up
        #  dog_request_id :integer
        #  dog_accept_id  :integer        

        #message IS recent 2 messages only, link to new page - view whole messages go to new page
#binding.pry        
        if (dog.status.include? "Woof-up") && ( (dog.status.include? "Approval") || (dog.status.include? "Request") )
            if dog.status.include? "Approval"
                #show page with Approval button and next page is to setup Woof-up date
                #message
                wuf = getWoof id, "Pending" #Woof.find_by(dog_accept_id: id)
                requestdog = Dog.find wuf.dog_request_id
                pageTitle = currstatus
                rname = requestdog.name
                if rname.chars.first != rname.chars.first.upcase
                    rname = rname.capitalize
                end
                caption = "#{rname} is waiting on your approval."
                messageArray = getRecentMessages wuf.messages
                renderPage = "/woofupdates/woofupdate"
                partnerDog_id = requestdog.id
            else
                #show page with details, no links -- coz approval pending
                #message
                wuf = getWoof id, "Pending" #Woof.find_by(dog_request_id: id)
                acceptdog = Dog.find wuf.dog_accept_id
                pageTitle = currstatus
                rname = acceptdog.name
                if rname.chars.first != rname.chars.first.upcase
                    rname = rname.capitalize
                end
                caption = "You are waiting on #{rname}'s approval."
                messageArray = getRecentMessages wuf.messages
                renderPage = "/woofupdates/woofupdate"
                partnerDog_id = acceptdog.id
            end
        end

#binding.pry
        #beyond this stage, both have same status

        currstatus = "Set Woof-up"
        if dog.status.include? currstatus
            #show page to setup the woof-up, to update details
            #message
            wuf = getWoof id, currstatus
            pageTitle = currstatus
            caption = "Enter details for the Woof-up."
            messageArray = getRecentMessages wuf.messages
            renderPage = "/woofupdates/woof"
            partnerDog_id = (getWoofPartnerDog id, wuf).id
#binding.pry
        end

        currstatus = "Woof-up Reminder"
        if dog.status.include? currstatus
            #get woof up date
            #if woof-up date is expired
                #change status to "Woof-up Expired"
                #show page with options to set up Breeding Appointment, Dogwalk Date or Break-up (links)
            #else
                #show page to update woof-up details
                #message
#binding.pry
            wuf = getWoof id, currstatus
#binding.pry
            wufup = Woofupdate.find_by(woof_id: wuf.id)
            woofupdate_when = wufup.woofdate
            woofupdate_where = wufup.place
#binding.pry
            expired = DateTime.now.to_date > wufup.woofdate
#binding.pry
            partnerDog = getWoofPartnerDog id, wuf
            messageArray = getRecentMessages wuf.messages
            partnerDog_id = partnerDog.id

            rname = partnerDog.name
            if rname.chars.first != rname.chars.first.upcase
                rname = rname.capitalize
            end

            if expired
                updateStatusWoofupExpired wuf
                #wuf.status = "Woof-up Expired"
                pageTitle = "Post Woof-up Options"
                caption = "Your partner dog, #{rname}, is available for:"
                wuf.update(:status => "Woof-up Expired")
                renderPage = "/breedappts/options"      
                eligibleForBreedingAppt = checkEligibleBreedingAppt dog.id, partnerDog.id     
            else
                pageTitle = currstatus
                caption = "Please make sure to get in touch with #{rname}'s owner to push through with the woof-up."
                renderPage = "/woofupdates/setupwoofup" 
                
            end
        end
#binding.pry
        currstatus = "Woof-up Expired"
        if dog.status.include? currstatus
            #show page with options to set up Breeding Appointment, Dogwalk Date or Break-up (links)
            #show page to set up breeding appointment details
            #message
            wuf = getWoof id, currstatus
            pageTitle = "Post Woof-up Options"
            partnerDog = getWoofPartnerDog id, wuf
            rname = partnerDog.name
            if rname.chars.first != rname.chars.first.upcase
                rname = rname.capitalize
            end
            caption = "Your partner dog, #{rname}, is available for:"
            messageArray = getRecentMessages wuf.messages
            partnerDog_id = partnerDog.id

            woofupdate = Woofupdate.find_by(woof_id: wuf.id)
            woofupdate_when = woofupdate.woofdate
            woofupdate_where = woofupdate.place
#binding.pry
            if ( woofupdate.status.present? && !(woofupdate.status.empty?) && (woofupdate.status == "Confirmed") )
                    woofupdateconfirmed = true
            end
            eligibleForBreedingAppt = checkEligibleBreedingAppt dog.id, partnerDog.id
#binding.pry
            #LOOK UP Breeadappts table
            #if no entry for both dos as partner
            renderPage = "/breedappts/options"  
            #else
            #renderPage is = "'/dogwalkdates/options"
        end

        currstatus = "Breeding Appointment Reminder"
        if dog.status.include? currstatus
            #get woof up date
            #if woof-up date is expired
                #change status to "Dogwalk Date or Break-up?"
            #else
                #show page to update breeding appt details
                #message

            wuf = getWoof id, currstatus
            bp = Breedappt.find_by woof_id: wuf.id 
            expired = DateTime.now.to_date > bp.breeddate

            partnerDog = getWoofPartnerDog id, wuf
            messageArray = getRecentMessages wuf.messages
            partnerDog_id = partnerDog.id

            rname = partnerDog.name
            if rname.chars.first != rname.chars.first.upcase
                rname = rname.capitalize
            end

            breedappt_when = bp.breeddate
            breedappt_where = bp.place
            eligibleForBreedingAppt = checkEligibleBreedingAppt dog.id, partnerDog.id
#binding.pry
            if expired
                updateStatusPostWoofExpired wuf, "Breeding Appointment Expired"
                pageTitle = "More Woof-up Options"
                caption = "Your partner dog, #{rname}, is available for:"
                #wuf.update(:status => "Breeding Appointment Expired")
                renderPage = "/dogwalkdates/options"                
            else
                pageTitle = currstatus
                caption = "Please make sure to get in touch with #{rname}'s owner to push through with the breeding appointment."
                renderPage = "/breedappts/reminder"  
            end
        end


        currstatus = "Breeding Appointment Expired"
        if dog.status.include? currstatus
            #show page with options to set up Dogwalk Date or Break-up (links)
            #show page to set up breeding appointment details
            #message
            wuf = getWoof id, currstatus
            pageTitle = "More Woof-up Options"    
#binding.pry
            partnerDog = getWoofPartnerDog id, wuf
            rname = partnerDog.name
            if rname.chars.first != rname.chars.first.upcase
                rname = rname.capitalize
            end
            caption = "Your partner dog, #{rname}, is available for:"
            messageArray = getRecentMessages wuf.messages
            partnerDog_id = partnerDog.id

            breedappt = Breedappt.find_by(woof_id: wuf.id)
            breedappt_when = breedappt.breeddate
            breedappt_where = breedappt.place
            eligibleForBreedingAppt = checkEligibleBreedingAppt dog.id, partnerDog.id 
#binding.pry
            if ( breedappt.status.present? && !(breedappt.status.empty?) && (breedappt.status == "Confirmed") )
                breedapptconfirmed = true
            end
#binding.pry
            renderPage = "/dogwalkdates/options"   
        end


        currstatus = "Dogwalk Date Reminder"
        if dog.status.include? currstatus
            #get woof up date
            #if woof-up date is expired
                #change status to "Dogwalk Date or Breakup?"
            #else
                #show page to update dogwalk date details
                #message

            wuf = getWoof id, currstatus

            dw = Dogwalkdate.where(woof_id: wuf.id).where(status: [nil, ""])
binding.pry
            expired = DateTime.now.to_date > dw[0][:walkdate]
binding.pry
            partnerDog = getWoofPartnerDog id, wuf
            messageArray = getRecentMessages wuf.messages
            partnerDog_id = partnerDog.id

            rname = partnerDog.name
            if rname.chars.first != rname.chars.first.upcase
                rname = rname.capitalize
            end

            walkdate_when = dw[0][:walkdate]
            walkdate_where = dw[0][:place]
            eligibleForBreedingAppt = checkEligibleBreedingAppt dog.id, partnerDog.id
            hasBAppt = hasBreedingAppt dog.id, partnerDog.id
binding.pry
            if expired
                updateStatusPostWoofExpired wuf, "Dogwalk Date Expired"
                pageTitle = "More Woof-up Options"
                caption = "Your partner dog, #{rname}, is available for:"
                
                #if hasBAppt
                #    renderPage = "/dogwalkdates/options"  
                #else
                    renderPage = "/dogwalkdates/optionsdwonly" 
                #end             
            else
                pageTitle = currstatus
                caption = "Please make sure to get in touch with #{rname}'s owner to push through with the dogwalk date."
                renderPage = "/dogwalkdates/reminder" 
            end
        end

        currstatus = "Dogwalk Date Expired"
        if dog.status.include? currstatus
            #check date today if it's more than 1 year since last breeding 
                #show page with options to set up Breeding Appointment, Dogwalk Date or Break-up (links)
                #message
            #else
                #show page with options to set up Dogwalk Date or Break-up (links)
                #message
 
            wuf = getWoof id, currstatus
            pageTitle = "More Woof-up Options"    
#binding.pry
            partnerDog = getWoofPartnerDog id, wuf
            rname = partnerDog.name
            if rname.chars.first != rname.chars.first.upcase
                rname = rname.capitalize
            end
            caption = "Your partner dog, #{rname}, is available for:"
            messageArray = getRecentMessages wuf.messages
            partnerDog_id = partnerDog.id

            eligibleForBreedingAppt = checkEligibleBreedingAppt dog.id, partnerDog.id
            dw = Dogwalkdate.where(woof_id: wuf.id).where(status: [nil, ""]).first #Dogwalkdate.find_by woof_id: wuf.id 
            if dw == nil #has status already
                #try again
                #dw = Dogwalkdate.where(woof_id: wuf.id).where(status: "Confirmed").first
                #if dw != nil
                    walkdateconfirmed = true
                #end
            else
                walkdate_when = dw.walkdate
                walkdate_where = dw.place
            end
            
#binding.pry
            #if ( dw.status.present? && !(dw.status.empty?) && (dw.status == "Confirmed") )
            #    walkdateconfirmed = true
            #end
binding.pry
            renderPage = "/dogwalkdates/optionsdwonly" 

        end

        #Note once 'Break-up' is chosen, STATUS back to 'Available'
#binding.pry
        partnerDog_img = getDogImage partnerDog_id
        partnerDog_name = getDogName partnerDog_id

        return {
            :woof_id => wuf.id,
            :msgArray => messageArray,
            :pageToRender => renderPage,
            :heading => pageTitle,
            :subheading => caption,
            :partnerDog_id => partnerDog_id,
            :partnerDog_img => partnerDog_img,
            :partnerDog_name => partnerDog_name,
            :currentDog_img => dog.image,
            :currentDog_name => dog.name,
            :currentStatus => dog.status,
            :woofupdateconfirmed => woofupdateconfirmed,
            :breedapptconfirmed => breedapptconfirmed,
            :walkdateconfirmed => walkdateconfirmed,
            :woofupdate_when => woofupdate_when,
            :woofupdate_where => woofupdate_where,
            :breedappt_when => breedappt_when,
            :breedappt_where => breedappt_where,
            :walkdate_when => walkdate_when,
            :walkdate_where => walkdate_where,
            :eligibleForBreedingAppt => eligibleForBreedingAppt
        }
    end #method
end #class
