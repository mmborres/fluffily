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

end
