class AdminController < ApplicationController

  def index
  end

  def emailtest
    @failure = false
    begin
      @contact = Crm::Contact.find(3) # me!
      # NewsletterMailer.welcome(@contact).deliver_later
      NewsletterMailer.welcome(@contact).deliver_now
    rescue
      @failure = true
    end
  end

end
