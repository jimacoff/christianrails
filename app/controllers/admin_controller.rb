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

  def receipttest
    @failure = false
    begin
      @order = current_user.orders.first # mine!
      ChristianMailer.ebook_receipt(@order).deliver_now
    rescue
      @failure = true
    end
  end

  def crm_stats
    @assistants = Crm::Assistant.all.sort{|a,b| b.total_activity_volume <=> a.total_activity_volume }
  end

end
