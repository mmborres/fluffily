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
    def updateStatusDogwalkDateorBreakup wuf
        #set to "Dogwalk Date or Break-up"
        wuf.update(:status => "Dogwalk Date or Break-up")
        request_dog = Dog.find wuf.dog_request_id
        accept_dog = Dog.find wuf.dog_accept_id

        request_dog.update(:status => "Dogwalk Date or Break-up")
        accept_dog.update(:status => "Dogwalk Date or Break-up")
    end


    public 
    def getWoof (id, currstatus)
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
        partnerDog = nil
        if id == wuf.dog_accept_id.to_s
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
    def getStatusPageDetails id
        dog = Dog.find id
        currstatus = dog.status
        wuf = nil
        messageArray = [] #last 2 messages if there are
        pageTitle = ""
        caption = ""
        partnerDog_id = 0
        woofupdateconfirmed = false

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
                renderPage = "/breedappts/breedappt"                
            else
                pageTitle = currstatus
                caption = "Please make sure to get in touch with #{rname}'s owner to push through with the woof-up."
                renderPage = "/woofupdates/setupwoofup" 
                woofupdate_when = wufup.woofdate
                woofupdate_where = wufup.place
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
#binding.pry
            if ( woofupdate.status.present? && !(woofupdate.status.empty?) && (woofupdate.status == "Confirmed") )
                    woofupdateconfirmed = true
            end
#binding.pry
            renderPage = "/breedappts/options"  
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
            expired = false
            #Date.now > wuf.woofdate
            #DateTime.now.to_date > wuf.woofdate
            partnerDog = getWoofPartnerDog id, wuf
            messageArray = getRecentMessages wuf.messages
            partnerDog_id = partnerDog.id

            rname = partnerDog.name
            if rname.chars.first != rname.chars.first.upcase
                rname = rname.capitalize
            end

            if expired
                updateStatusDogwalkDateorBreakup wuf
                #wuf.status = "Dogwalk Date or Break-up"
                pageTitle = "More Woof-up Options"
                caption = "Your partner dog, #{rname}, is available for:"
                wuf.update(:status => "Dogwalk Date or Break-up")
                renderPage = "/dogwalkdates/options"                
            else
                pageTitle = currstatus
                caption = "Please make sure to get in touch with #{rname}'s owner to push through with the breeding appointment."
                renderPage = "/breedappts/breedappt"  
            end
        end

=begin
        currstatus = "Breeding Appointment Expired"
        if dog.status.include? currstatus
            #show page with options to set up Dogwalk Date or Break-up (links)
            #show page to set up breeding appointment details
            #message
            wuf = getWoof id, currstatus
            pageTitle = "More Woof-up Options"    
            partnerDog = getWoofPartnerDog id, wuf
            caption = "#{partnerDog.name.capitalize} is available for:"
            messageArray = wuf.messages[0..1]
            partnerDog_id = partnerDog.id
        end
=end

        currstatus = "Dogwalk Date Reminder"
        if dog.status.include? currstatus
            #get woof up date
            #if woof-up date is expired
                #change status to "Dogwalk Date or Breakup?"
            #else
                #show page to update dogwalk date details
                #message

            wuf = getWoof id, currstatus
            expired = DateTime.now > wuf.updated_at
            partnerDog = getWoofPartnerDog id, wuf
            messageArray = getRecentMessages wuf.messages
            partnerDog_id = partnerDog.id

            if expired
                updateStatusDogwalkDateorBreakup wuf
                #wuf.status = "Dogwalk Date or Break-up"
                pageTitle = "More Woof-up Options"
                caption = "Your partner dog, #{partnerDog.name.capitalize}, is available for:"
                wuf.update(:status => "Dogwalk Date or Break-up")
                renderPage = "/dogwalkdates/dogwalkdate"                
            else
                pageTitle = currstatus
                caption = "Please make sure to get in touch with #{partnerDog.name.capitalize}'s owner to push through with the dogwalk date."
                renderPage = "/dogwalkdates/dogwalkdate" 
            end
        end

        currstatus = "Dogwalk Date or Break-up"
        if dog.status.include? currstatus
            #check date today if it's more than 1 year since last breeding 
                #show page with options to set up Breeding Appointment, Dogwalk Date or Break-up (links)
                #message
            #else
                #show page with options to set up Dogwalk Date or Break-up (links)
                #message
            wuf = getWoof id, currstatus
            pageTitle = "More Woof-up Options"
            partnerDog = getWoofPartnerDog id, wuf
            messageArray = getRecentMessages wuf.messages
            partnerDog_id = partnerDog.id
            caption = "Your partner dog, #{partnerDog.name.capitalize}, is available for:"
            renderPage = "/dogwalkdates/options" 
        end

        #Note once 'Break-up' is chosen, STATUS back to 'Available'
#binding.pry
        partnerDog_img = getDogImage partnerDog_id
        
        return {
            :woof_id => wuf.id,
            :msgArray => messageArray,
            :pageToRender => renderPage,
            :heading => pageTitle,
            :subheading => caption,
            :partnerDog_id => partnerDog_id,
            :partnerDog_img => partnerDog_img,
            :currentDog_img => dog.image,
            :currentStatus => dog.status,
            :woofupdateconfirmed => woofupdateconfirmed,
            :woofupdate_when => woofupdate_when,
            :woofupdate_where => woofupdate_where
        }
    end #method
end #class
