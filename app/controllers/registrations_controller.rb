class RegistrationsController < Devise::RegistrationsController

  include StoreHelper

  after_action :send_registration_notification, only: [:create]
  after_action :sign_up_to_mailing_list,        only: [:create]
  after_action :associate_orphan_woods_player_with_new_user, only: [:create]
  after_action :give_free_gifts, only: [:create]

  private

    def send_registration_notification
      if @user && @user.persisted?
        record_positive_event(Log::STORE, "New account created")
        AdminMailer.account_signup( @user ).deliver_now
      end
    end

    def sign_up_to_mailing_list
      if @user && @user.persisted? && @user.send_me_emails
        NewsletterSignup.create(email: @user.email)
      end
    end

    def associate_orphan_woods_player_with_new_user
      if @user && @user.persisted?
        if !current_user.player && session[:woods_player_id] && !session[:woods_player_id].blank?
          player_to_associate = Woods::Player.find( session[:woods_player_id] )
          current_user.player = player_to_associate
        end
      end
    end

    def give_free_gifts
      if @user && @user.persisted?
        Store::Product.where( free_on_signup: true ).each do |free_product|
          give_product_to_user!( free_product, @user, "On sign-up" )
        end
      end
    end

    def sign_up_params
      params.require(:user).permit(:username, :first_name, :last_name, :country, :email,
                                   :password, :password_confirmation, :send_me_emails, :company, :purchaser)
    end

    def account_update_params
      params.require(:user).permit(:username, :first_name, :last_name, :country, :email,
                                   :password, :password_confirmation, :current_password, :company, :purchaser)
    end

end
