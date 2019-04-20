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
        name = "Sender"
        dog = Dog.find givenID
        name = dog.name
        
        return name
    end


end
