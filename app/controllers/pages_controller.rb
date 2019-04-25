class PagesController < ApplicationController
  def home
    if @current_user.present? 
      if @current_user.dogs.present?
        user = User.new
        array = user.getFeaturedNotication @current_user.dogs
        @featureImage = array[:image]
        @featureText = array[:text]
#binding.pry
      else #no registered dog yet
        @featureImage = "https://previews.123rf.com/images/damedeeso/damedeeso1407/damedeeso140700058/30507565-couple-of-dogs-in-love-very-close-together-lying-on-grass-in-the-park-with-sunglasses-chilling-out.jpg"
        @featureText = "What are you waiting for? Register your dog so they find their fluffily ever after."
      end
    end #user
  end
end
