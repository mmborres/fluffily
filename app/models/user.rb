# == Schema Information
#
# Table name: users
#
#  id                 :bigint(8)        not null, primary key
#  email              :text
#  password_digest    :text
#  dob                :date
#  admin              :boolean
#  name               :text
#  image              :text
#  sex                :text
#  has_registered_dog :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class User < ApplicationRecord
    has_secure_password
    has_many :dogs

    #Rails validation #before running user.save
    validates :email, :presence => true, :uniqueness => true
    validates :password, :presence => true
    validate :at_least_18

    def at_least_18
        if self.dob
        errors.add("Date of Birth:", 'You must be 18 years or older.') if self.dob > 18.years.ago.to_date
        end
    end


    public
    def updateSpecific (id, name, image)
        updatestatement = "UPDATE users SET name='#{name}' WHERE id=#{id}"
        ExecuteSql.run updatestatement, mode: :raw
        if image.present?
            updatestatement = "UPDATE users SET image='#{image}' WHERE id=#{id}"
            ExecuteSql.run updatestatement, mode: :raw
        end
    end

    public 
    def getText (status, name)
        text = ""
        if status.include? "Available"
            text = "Excited? See potential matches for #{name}."
        end
        if status.include? "Set Woof-up"
            text = "What are you waiting for? Time to set up a woof-up for #{name}."
        end
        if status.include? "Request"
            text = "Update for you! Check the status of #{name}'s Woof-up Request."
        end
        if status.include? "Approval"
            text = "#{name} has a Woof-up Request waiting for your approval. Go on, woof-up!"
        end
        if status.include? "Reminder"
            text = "#{status}: Don't be late! Please check the details of #{name}'s upcoming woof-up."
        end
        if status.include? "Expired"
            text = "#{status}: How was #{name}'s recent woof-up? Please confirm, OR see more Woof-up options."
        end
        return text
    end

    public 
    def getFeaturedNotication dogsArray
        image = ""
        text = ""
#binding.pry
        if dogsArray.length == 1
            #assign 
            image = dogsArray[0][:image]
            text = getText dogsArray[0][:status], dogsArray[0][:name]
        else
            rid = rand dogsArray.length
            #featured dog is dogsArray[rid]
            image = dogsArray[rid][:image]
            text = getText dogsArray[rid][:status], dogsArray[rid][:name]
        end

        return {
            :image => image,
            :text => text
        }
    end
end
