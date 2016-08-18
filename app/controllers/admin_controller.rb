class AdminController < ApplicationController

  def index
  end

  def emailtest
    @failure = false
    begin
      @newsletter_signup = NewsletterSignup.find(1) # me!
      NewsletterMailer.welcome(@newsletter_signup).deliver_now
    rescue
      @failure = true
    end
  end

end
