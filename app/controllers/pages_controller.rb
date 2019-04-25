class PagesController < ApplicationController
  def home
    if @current_user.present? 
      if @current_user.dogs.present?
        user = User.new
        array = user.getFeaturedNotication @current_user.dogs
        @featureImage = array[:image]
        @featureText = array[:text]
#binding.pry
      end
    end
  end
end
