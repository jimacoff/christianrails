class Crm::ContactsController < Crm::CrmController

  before_action :set_crm_contact_secure, only: [:edit, :update, :destroy]

  ## LOGGED-IN ASSISTANTS ONLY

  def index
    @contacts = current_assistant.contacts.order('firstname asc')
  end

  def new
    @contact = Crm::Contact.new
  end

  def edit
  end

  def create
    @contact = Crm::Contact.new(crm_contact_params)
    @contact.assistant = current_assistant

    if @contact.save
      redirect_to crm_contacts_path, notice: 'Contact was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @contact.update(crm_contact_params)
      redirect_to crm_contacts_url, notice: 'Contact was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @contact.destroy!
    redirect_to crm_contacts_url, notice: 'Contact was successfully destroyed.'
  end

  private

    def set_crm_contact_secure
      @contact = Crm::Contact.find(params[:id])
      redirect_to(root_path) unless owns_assistant?( @contact.assistant )
    end

    def crm_contact_params
      params.require(:crm_contact).permit(:email, :firstname, :lastname, :business, :positiontitle, :source, :phone, :address)
    end

end
