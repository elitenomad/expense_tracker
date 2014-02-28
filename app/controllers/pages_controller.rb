class PagesController < ApplicationController
skip_before_filter :authenticate_user!, only: [:index,:about, :contact]

  def index
    render layout: "landing_layout"
  end

  def contact
  end

  def about
  end

  def sendemail
    begin
      UserMailer.feedback_mail(params).deliver
      UserMailer.contact_mail(params).deliver
      redirect_to root_path
    rescue
      flash.now[:notice] = "Error in sending email. Please try again"
      redirect_to root_path
    end
      
  end

end