class NewsletterSignupsController < ApplicationController
  skip_before_action :verify_is_admin, only: [:create]

  def index
    @newsletter_signups = NewsletterSignup.order('created_at desc')
  end

  def create
    @newsletter_signup = NewsletterSignup.new(newsletter_signup_params)

    respond_to do |format|
      if @newsletter_signup.save
        send_notifications
        format.json { render json: @newsletter_signup, status: :created }
      else
        format.json { render json: @newsletter_signup.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def newsletter_signup_params
      params.require(:newsletter_signup).permit(:email)
    end

    def send_notifications
      NewsletterMailer.welcome(@newsletter_signup).deliver_now
      AdminMailer.newsletter_signup(@newsletter_signup).deliver_now
    end

end