# == Schema Information
#
# Table name: breedappts
#
#  id             :bigint(8)        not null, primary key
#  dog_request_id :integer
#  dog_accept_id  :integer
#  status         :text
#  breeddate      :date
#  place          :text
#  image          :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Breedappt < ApplicationRecord
    belongs_to :woof, :optional => true
end
