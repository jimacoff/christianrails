class Crm::ContactsController < ApplicationController
  layout "crm"

  skip_before_action :verify_is_admin, only: [:newsletter_signup]

  def create
    @contact = Crm::Contact.new(crm_contact_params)

    respond_to do |format|
      if @contact.save
        format.html { redirect_to @contact, notice: 'Contact was successfully created.' }
        format.json { render action: 'show', status: :created, location: @contact }
      else
        format.html { render action: 'new' }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  def newsletter_signup
    @contact = Crm::Contact.new(crm_contact_params)
    @contact.assistant = Crm::Assistant.find(1)
    @contact.source = "Newsletter signup"

    respond_to do |format|
      if @contact.save
        # TODO mail off notifications
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
end
