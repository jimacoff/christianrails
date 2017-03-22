class RegistrationsController < Devise::RegistrationsController

  after_action :send_registration_notification, only: [:create]
  after_action :sign_up_to_mailing_list, only: [:create]

  private

  def sign_up_params
    params.require(:user).permit(:username, :first_name, :last_name, :country, :email, :password, :password_confirmation, :send_me_emails)
  end

  def account_update_params
    params.require(:user).permit(:username, :first_name, :last_name, :country, :email, :password, :password_confirmation, :current_password)
  end

  def send_registration_notification
    record_positive_event(Log::STORE, "New account created")
    AdminMailer.account_signup(@user).deliver_now
  end

  def sign_up_to_mailing_list
    NewsletterSignup.create(email: @user.email) if @user.send_me_emails
  end

end
