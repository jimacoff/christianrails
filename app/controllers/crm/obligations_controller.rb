class Crm::ObligationsController < ApplicationController
  layout "crm"

  before_action :set_crm_obligation_secure, only: [:edit, :update, :destroy]
  before_action :verify_has_assistant, except: [:newsletter_signup]

  def index
    @obligations = Crm::Obligation.order("due_at asc")
    @obligations ||= []
  end

  def new
    @obligation = Crm::Obligation.new
    get_contacts
  end

  def edit
    get_contacts
  end

  def create
    @obligation = Crm::Obligation.new(crm_obligation_params)

    @contact = Crm::Contact.find( crm_obligation_params[:contact_id] )
    verify_contact

    @obligation.assistant = current_assistant

    respond_to do |format|
      if @obligation.save
        format.html { redirect_to crm_obligations_path, notice: 'Obligation was successfully created.' }
      else
        get_contacts
        format.html { render action: 'new' }
      end
    end
  end

  def update
    @contact = Crm::Contact.find( crm_obligation_params[:contact_id] )
    verify_contact

    respond_to do |format|
      if @obligation.update(crm_obligation_params)
        format.html { redirect_to crm_obligations_path, notice: 'Obligation was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @obligation.destroy
    respond_to do |format|
      format.html { render action: 'index' }
    end
  end

  private
    def set_crm_obligation_secure
      @obligation = Crm::Obligation.find(params[:id])
      redirect_to(root_path) unless owns_assistant?( @obligation.assistant )
    end

    def crm_obligation_params
      params.require(:crm_obligation).permit(:contact_id, :name, :status_id, :due_at)
    end

    def get_contacts
      @contacts = Crm::Contact.where(assistant_id: current_assistant.id)
    end

    def verify_contact
      redirect_to(root_path) and return unless owns_assistant?( @contact.assistant )
      true
    end
end
