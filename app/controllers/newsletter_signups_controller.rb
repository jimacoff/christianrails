class NewsletterSignupsController < ApplicationController
  skip_before_action :verify_is_admin, only: [:create]

  ## PUBLIC

  def create
    @newsletter_signup = NewsletterSignup.new(newsletter_signup_params)

    if @newsletter_signup.save
      send_email_notifications
      record_positive_event(Log::STORE, "New newsletter signup")
      render json: @newsletter_signup, status: :created
    else
      render json: @newsletter_signup.errors, status: :unprocessable_entity
    end
  end

  ## ADMIN ONLY

  def index
    @newsletter_signups = NewsletterSignup.order('created_at desc')
  end

  private

    def newsletter_signup_params
      params.require(:newsletter_signup).permit(:email)
    end

    def send_email_notifications
      NewsletterMailer.welcome( @newsletter_signup ).deliver_now
      AdminMailer.newsletter_signup( @newsletter_signup ).deliver_now
    end

end
