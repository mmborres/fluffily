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

    public
    def getMatches requestor_id
    #get the dog first
    dog = ExecuteSql.run "SELECT * FROM dogs WHERE id=#{requestor_id}", mode: :raw
    #get the dog's preferences
    pref_sex = dog[0][12]
    pref_breed = dog[0][13]
    pref_color = dog[0][14]
    pref_location = dog[0][15]

    selectstatement = "SELECT * FROM dogs WHERE id<>#{requestor_id} AND upper(sex)='#{pref_sex.upcase}' "

    if !(pref_breed.upcase.include? "ANY")
        selectstatement += "AND upper(breed)='#{pref_breed.upcase}' "
    end
    if !(pref_color.upcase.include? "ANY")
        selectstatement += "AND upper(color)='#{pref_color.upcase}' "
    end
    if !(pref_location.upcase.include? "ANY")
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
            matchedDogs[i] = Dog.find id
#binding.pry
            i += 1;
        end
    end
#binding.pry    
    return matchedDogs
    end

    public
    def updateStatusCreate (request_id, accept_id)
#binding.pry
        request_dog = Dog.find request_id
        accept_dog = Dog.find accept_id

        request_dog.status = "Woof-up Request Sent"
        accept_dog.status = "Woof-up Pending Approval"
        request_dog.save
        accept_dog.save
    end

    public
    def updateStatusWoofupExpired wuf
        #set to "Woof-up Expired"
        request_dog = Dog.find wuf.dog_request_id
        accept_dog = Dog.find wuf.dog_accept_id

        request_dog.status = "Woof-up Expired"
        accept_dog.status = "Woof-up Expired"
        request_dog.save
        accept_dog.save
        #wuf.status = "Woof-up Expired"
    end

    public
    def updateStatusDogwalkDateorBreakup wuf
        #set to "Dogwalk Date or Break-up"
        wuf.status = "Dogwalk Date or Break-up"
        request_dog = Dog.find wuf.dog_request_id
        accept_dog = Dog.find wuf.dog_accept_id

        request_dog.status = "Dogwalk Date or Break-up"
        accept_dog.status = "Dogwalk Date or Break-up"
        request_dog.save
        accept_dog.save
    end


    public 
    def getWoof (id, currstatus)
        wuf = Woof.find_by(dog_accept_id: id, status: currstatus)
binding.pry
        if ( (wuf == nil) || (wuf == "") )
            wuf = Woof.find_by(dog_request_id: id, status: currstatus)
        end
binding.pry
        return wuf
    end

    public 
    def getWoofPartnerDog (id, wuf)
        partnerDog = nil
        if id == wuf.dog_accept_id
            partnerDog = Dog.find wuf.dog_request_id
        else
            partnerDog = Dog.find wuf.dog_accept_id
        end
        return partnerDog
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

        #Find Woof-up
        #  dog_request_id :integer
        #  dog_accept_id  :integer        

        #message IS recent 2 messages only, link to new page - view whole messages go to new page
#binding.pry        
        if (dog.status.include? "Woof-up") && !(dog.status.include? "Set")
            if dog.status.include? "Approval"
                #show page with Approval button and next page is to setup Woof-up date
                #message
                wuf = Woof.find_by(dog_accept_id: id)
                requestdog = Dog.find wuf.dog_request_id
                pageTitle = currstatus
                caption = "#{requestdog.name.capitalize} is waiting on your approval."
                messageArray = wuf.messages[0..1]
                renderPage = "/woofupdates/woofupdate"
                partnerDog_id = requestdog.id
            else
                #show page with details, no links -- coz approval pending
                #message
                wuf = Woof.find_by(dog_request_id: id)
                acceptdog = Dog.find wuf.dog_accept_id
                pageTitle = currstatus
                caption = "You are waiting on #{acceptdog.name.capitalize}'s approval."
                messageArray = wuf.messages[0..1]
                renderPage = "/woofupdates/woofupdate"
                partnerDog_id = acceptdog.id
            end
        end

binding.pry
        #beyond this stage, both have same status

        currstatus = "Set Woof-up"
        if dog.status.include? currstatus
            #show page to setup the woof-up, to update details
            #message
            wuf = getWoof id, currstatus
            pageTitle = currstatus
            caption = "Enter details for the Woof-up."
            messageArray = wuf.messages[0..1]
            renderPage = "/woofupdates/setupwoofup"
            partnerDog_id = (getWoofPartnerDog id, wuf).id
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

            wuf = getWoof id, currstatus
            expired = DateTime.now > wuf.updated_at
            partnerDog = getWoofPartnerDog id, wuf
            messageArray = wuf.messages[0..1]
            partnerDog_id = partnerDog.id

            if expired
                updateStatusWoofupExpired wuf
                wuf.status = "Woof-up Expired"
                pageTitle = "Post Woof-up Options"
                caption = "#{partnerDog.name.capitalize} is available for:"
                wuf.save
                renderPage = "/breedappts/breedappt"                
            else
                pageTitle = currstatus
                caption = "Please make sure to get in touch with #{partnerDog.name.capitalize}'s owner to push through with the woof-up."
                renderPage = "/woofupdates/setupwoofup" 
            end
        end

        currstatus = "Woof-up Expired"
        if dog.status.include? currstatus
            #show page with options to set up Breeding Appointment, Dogwalk Date or Break-up (links)
            #show page to set up breeding appointment details
            #message
            wuf = getWoof id, currstatus
            pageTitle = "Post Woof-up Options"
            caption = "#{partnerDog.name.capitalize} is available for:"
            partnerDog = getWoofPartnerDog id, wuf
            messageArray = wuf.messages[0..1]
            partnerDog_id = partnerDog.id
            renderPage = "/breedappts/breedappt"  
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
            expired = DateTime.now > wuf.updated_at
            partnerDog = getWoofPartnerDog id, wuf
            messageArray = wuf.messages[0..1]
            partnerDog_id = partnerDog.id

            if expired
                updateStatusDogwalkDateorBreakup wuf
                wuf.status = "Dogwalk Date or Break-up"
                pageTitle = "More Woof-up Options"
                caption = "#{partnerDog.name.capitalize} is available for:"
                wuf.save
                renderPage = "/dogwalkdates/dogwalkdate"                
            else
                pageTitle = currstatus
                caption = "Please make sure to get in touch with #{partnerDog.name.capitalize}'s owner to push through with the breeding appointment."
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
            messageArray = wuf.messages[0..1]
            partnerDog_id = partnerDog.id

            if expired
                updateStatusDogwalkDateorBreakup wuf
                wuf.status = "Dogwalk Date or Break-up"
                pageTitle = "More Woof-up Options"
                caption = "#{partnerDog.name.capitalize} is available for:"
                wuf.save
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
            messageArray = wuf.messages[0..1]
            partnerDog_id = partnerDog.id
            caption = "#{partnerDog.name.capitalize} is available for:"
            renderPage = "/dogwalkdates/dogwalkdate" 
        end

        #Note once 'Break-up' is chosen, STATUS back to 'Available'
binding.pry
        return {
            #:woof => wuf,
            :msgArray => messageArray,
            :pageToRender => renderPage,
            :heading => pageTitle,
            :subheading => caption,
            :partnerDog_id => partnerDog_id
        }
    end #method
end #class
