# == Schema Information
#
# Table name: preferences
#
#  id         :bigint(8)        not null, primary key
#  dog_id     :integer
#  sex        :text
#  breed      :text
#  color      :text
#  location   :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Preference < ApplicationRecord
    belongs_to :dog, :optional => true
end
