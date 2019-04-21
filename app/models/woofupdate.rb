# == Schema Information
#
# Table name: woofupdates
#
#  id             :bigint(8)        not null, primary key
#  dog_request_id :integer
#  dog_accept_id  :integer
#  status         :text
#  woofdate       :date
#  place          :text
#  image          :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Woofupdate < ApplicationRecord
end
