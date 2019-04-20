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
end
