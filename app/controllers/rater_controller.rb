class RaterController < ApplicationController

  def create
    if member_signed_in?
      obj = params[:klass].classify.constantize.find(params[:id])
      obj.rate params[:score].to_f, current_member, params[:dimension]

      update_stars

      render :json => true
    else
      render :json => false
    end
  end

  private

  def update_stars

    stars = StarsOfComment.where(ad_id: params[:id]).first

    if params[:score] == 5
      stars.update_attribute(:stars5, "#{stars.stars5.to_f + params[:score].to_f}")
    elsif params[:score] == 4
      stars.update_attribute(:stars4, "#{stars.stars4.to_f + params[:score].to_f}")
    elsif params[:score] == 3
      stars.update_attribute(:stars3, "#{stars.stars3.to_f + params[:score].to_f}")
    elsif params[:score] == 2
      stars.update_attribute(:stars2, "#{stars.stars2.to_f + params[:score].to_f}")
    elsif params[:score] == 1
      stars.update_attribute(:stars1, "#{stars.stars1.to_f + params[:score].to_f}")
    end

    stars.update_attribute(:average_stars5, "#{((stars.stars5*5)*100) / totalStars}")
    # stars.average_stars5 = StarsOfComment.where(id: stars.id)
    #                              .sum("((stars5*5)*100) / totalStars")
    stars.update_attribute(:average_stars4, "#{((stars.stars4*4)*100) / totalStars}")
    # stars.average_stars4 = StarsOfComment.where(id: stars.id)
    #                              .sum("((stars4*4)*100) / totalStars")
    stars.update_attribute(:average_stars3, "#{((stars.stars3*3)*100) / totalStars}")
    # stars.average_stars3 = StarsOfComment.where(id: stars.id)
                                 # .sum("((stars3*3)*100) / totalStars")
    stars.update_attribute(:average_stars2, "#{((stars.stars2*2)*100) / totalStars}")
    # stars.average_stars2 = StarsOfComment.where(id: stars.id)
                                 # .sum("((stars2*2)*100) / totalStars")
    stars.update_attribute(:average_stars1, "#{(stars.stars1*100) / totalStars}")
    # stars.average_stars1 = StarsOfComment.where(id: stars.id)
                                 # .sum("(stars1*100) / totalStars")
    # stars.save!
    # stars.errors.full_messages
    # stars.save
  end
end
