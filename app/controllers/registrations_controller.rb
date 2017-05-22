class RegistrationsController < Devise::RegistrationsController

  after_action :send_registration_notification, only: [:create]
  after_action :sign_up_to_mailing_list, only: [:create]
  after_action :associate_orphan_woods_player_with_new_user, only: [:create]

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

  def associate_orphan_woods_player_with_new_user
    if current_user
      if !current_user.player && session[:woods_player_id] && !session[:woods_player_id].blank?
        player_to_associate = Woods::Player.find( session[:woods_player_id] )
        current_user.player = player_to_associate
        pp "### Associating orphan player with logging-in user."
      end
    end
  end

end
