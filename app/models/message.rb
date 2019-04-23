# == Schema Information
#
# Table name: messages
#
#  id           :bigint(8)        not null, primary key
#  woof_id      :integer
#  sender_id    :integer
#  sender_name  :text
#  message_text :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Message < ApplicationRecord
    belongs_to :woof, :optional => true

    public 
    def getName givenID
#binding.pry
        name = "Sender"
        dog = Dog.find givenID
        name = dog.name    
        return name
    end

    public 
    def saveMessage (woofid, request_id, messageText, sendername)
        woof = Woof.find woofid
        message = Message.new
        message.sender_id = request_id #initiator
        message.sender_name = sendername
        message.message_text = messageText
        woof.messages << message
        message.save
    end

    public
    def getDogImages (id, woofid)
        woof = Woof.find woofid
        dog = Dog.find id
#binding.pry
        #just making sure, get correct partner
        if id == woof.dog_request_id.to_s
            partnerDog = Dog.find woof.dog_accept_id
        end
        if id == woof.dog_accept_id.to_s
            partnerDog = Dog.find woof.dog_request_id
        end

        return {
            :dogimage => dog.image,
            :partnerDogimage => partnerDog.image,
            :partnerDogname => partnerDog.name
        }
    end

end
