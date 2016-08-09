class Crm::ContactsController < ApplicationController
  layout "crm"

  skip_before_action :verify_is_admin, only: [:newsletter_signup]
  before_action :verify_has_assistant, except: [:newsletter_signup]

  def index
    @contacts = current_assistant.contacts
  end

  def new
    # TODO
  end

  def create
    @contact = Crm::Contact.new(crm_contact_params)

    respond_to do |format|
      if @contact.save
        format.html { redirect_to @contact, notice: 'Contact was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def newsletter_signup
    @contact = Crm::Contact.new(crm_contact_params)
    @contact.assistant = Crm::Assistant.find(1)  # mine
    @contact.source = "Newsletter signup"

    respond_to do |format|
      if @contact.save
        send_notifications
        format.json { render json: @contact, status: :created }
      else
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def set_crm_contact
      @contact = Crm::Contact.find(params[:id])
    end

    def crm_contact_params
      params.require(:crm_contact).permit(:email)
    end

    def send_notifications
      NewsletterMailer.welcome(@contact).deliver_now
      AdminMailer.newsletter_signup(@contact).deliver_now
    end
end
