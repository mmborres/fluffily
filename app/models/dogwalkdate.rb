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

end
