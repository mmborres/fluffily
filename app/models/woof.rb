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

        request_dog.status = "Woof-up Pending"
        accept_dog.status = "Woof-up Pending Approval"
        request_dog.save
        accept_dog.save
    end


    public
    def getStatusPageDetails id
        dog = Dog.find id
        status = dog.status

        #message IS recent 2 messages only, link to new page - view whole messages go to new page

        if dog.status.include? "Set Woof-up"
            #show page to setup the woof-up, to update details
            #message
        end

        if dog.status.include? "Woof-up Reminder"
            #get woof up date
            #if woof-up date is expired
                #change status to "Set Breeding Appointment"
                #show page with options to set up Breeding Appointment, Dogwalk Date or Break-up (links)
            #else
                #show page to update woof-up details
                #message
        end

        if dog.status.include? "Woof-up Pending"
            if dog.status.include? "Approval"
                #show page with Approval button and next page is to setup Woof-up date
                #message
            else
                #show page with details, no links -- coz approval pending
                #message
            end
        end

        if dog.status.include? "Set Breeding Appointment"
            #show page with options to set up Breeding Appointment, Dogwalk Date or Break-up (links)
            #show page to set up breeding appointment details
            #message
        end

        if dog.status.include? "Breeding Appointment Reminder"
            #get woof up date
            #if woof-up date is expired
                #change status to "Dogwalk Date or Break-up?"
            #else
                #show page to update breeding appt details
                #message
        end

        if dog.status.include? "Dogwalk Date Reminder"
            #get woof up date
            #if woof-up date is expired
                #change status to "Dogwalk Date or Breakup?"
            #else
                #show page to update dogwalk date details
                #message
        end

        if dog.status.include? "Dogwalk Date or Break-up"
            #check date today if it's more than 1 year since last breeding 
                #show page with options to set up Breeding Appointment, Dogwalk Date or Break-up (links)
                #message
            #else
                #show page with options to set up Dogwalk Date or Break-up (links)
                #message
        end

        #Note once 'Break-up' is chosen, STATUS back to 'Available'

    end #method
end #class
