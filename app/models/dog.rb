# == Schema Information
#
# Table name: dogs
#
#  id             :bigint(8)        not null, primary key
#  dob            :date
#  name           :text
#  image          :text
#  sex            :text
#  breed          :text
#  color          :text
#  user_id        :integer
#  location       :text
#  imagewithowner :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  pref_sex       :text
#  pref_breed     :text
#  pref_color     :text
#  pref_location  :text
#  status         :text
#

class Dog < ApplicationRecord
    belongs_to :user, :optional => true

    validates :name, :presence => true
    validates :sex, :presence => true
    validates :breed, :presence => true
    validates :color, :presence => true
    validates :location, :presence => true

=begin
    validates :pref_sex, :presence => true
    validates :pref_breed, :presence => true
    validates :pref_color, :presence => true
    validates :pref_location, :presence => true
=end

    public
    def setbool
        @booleanMale = false
        @booleanFemale = false
        @booleanMalepref_sex = false
        @booleanFemalepref_sex = false
    end

    public
    def run_preferences
#binding.pry
    end

    public
    def hasMatchesActivity dogsHash
        #search woofs
        #search dogwalkdates
        #search breedappts
    end

    public
    def getOwnerName ownerid
        user = User.find ownerid
#binding.pry
        name = ( user.name == nil || user.name.empty? ) ? "" : (" " + user.name)
        return name
    end

    public 
    def getWoofPartnerDog dog
#binding.pry
        partnerDog = nil
        wuf = Woof.find_by(status: dog.status, dog_request_id: dog.id)
        if wuf == nil
            wuf = Woof.find_by(status: dog.status, dog_accept_id: dog.id)
        end
        if wuf == nil
            wuf = Woof.find_by(status: "Pending", dog_request_id: dog.id)
        end
        if wuf == nil
            wuf = Woof.find_by(status: "Pending", dog_accept_id: dog.id)
        end

        if wuf != nil
#binding.pry
            if dog.id == wuf.dog_accept_id
                partnerDog = Dog.find wuf.dog_request_id
            else
                partnerDog = Dog.find wuf.dog_accept_id
            end
        end
#binding.pry
        return {
            :partnerDog => partnerDog,
            :woofid => wuf.id
        }
    end


end
