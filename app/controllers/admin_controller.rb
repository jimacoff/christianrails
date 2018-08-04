class AdminController < ApplicationController

  include StoreHelper

  # blog helpers for stats purposes
  include BadgerHelper
  include BlogHelper
  include ButlerHelper
  include ComputersHelper
  include QuailHelper

  before_action :get_products, only: [:index]

  ## ADMIN ONLY

  def index
    @days_since_blog_post     = get_days_since( date_of_last_blog_post )
    @days_since_last_signup   = get_days_since( date_of_last_created( User ) )
    @days_since_last_download = {}
    @days_since_last_download[:book] = get_days_since( date_of_last_created( Store::Download ) )
    @days_since_last_download[:item] = get_days_since( date_of_last_created( Woods::ItemDownload ) )
    @days_since_last_purchase = {}
    @days_since_last_purchase[:digital]  = get_days_since( date_of_last_created( Store::DigitalPurchase ) )
    @days_since_last_purchase[:physical] = get_days_since( date_of_last_created( Store::PhysicalPurchase ) )
    @days_since_last_melon_click = get_days_since( date_of_last_created( Melon ) )
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

  def cause_exception
    1/0
  end

  def receipttest
    @failure = false
    begin
      @order = current_user.orders.first # mine!
      StoreMailer.ebook_receipt( @order ).deliver_now
    rescue => e
      Rails.logger.warn(e)
      @failure = true
    end
  end

  def crm_stats
    @assistants = Crm::Assistant.all.sort{|a,b| b.total_activity_volume <=> a.total_activity_volume }
  end

  private

    def date_of_last_blog_post
      date_data = []
      date_data << all_badger_posts.collect{     |x| date_of (get_date_from( x[:slug] ) ) }
      date_data << all_blog_posts.collect{       |x| date_of (get_date_from( x[:title]) ) }
      date_data << all_butler_posts.collect{     |x| date_of (get_date_from( x[:title]) ) }
      date_data << all_computers_posts.collect{  |x| date_of (get_date_from( x[:slug] ) ) }
      date_data << all_scalequail_posts.collect{ |x| date_of (get_date_from( x[:date] ) ) }
      date_data.flatten.max.to_datetime
    end

    def get_date_from( data )
      data[0..7]
    end

    def get_days_since( date )
      date ? ((DateTime.current.to_i - date.to_i) / 86400).to_s : "n/a"
    end

    def date_of_last_created( klass )
      klass.count > 0 ? klass.order('created_at desc').take.created_at : nil
    end

end
