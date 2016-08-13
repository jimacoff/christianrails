class Crm::ContactsController < Crm::CrmController

  skip_before_action :verify_has_assistant, only: [:newsletter_signup]
  before_action :set_crm_contact_secure, only: [:edit, :update, :destroy]

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

    respond_to do |format|
      if @contact.save
        format.html { redirect_to crm_contacts_path, notice: 'Contact was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @contact.update(crm_contact_params)
        format.html { redirect_to crm_contacts_url, notice: 'Contact was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @contact.destroy!

    respond_to do |format|
      format.html { redirect_to crm_contacts_url, notice: 'Contact was successfully destroyed.' }
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

    def set_crm_contact_secure
      @contact = Crm::Contact.find(params[:id])
      redirect_to(root_path) unless owns_assistant?( @contact.assistant )
    end

    def crm_contact_params
      params.require(:crm_contact).permit(:email, :firstname, :lastname, :business, :positiontitle, :source, :phone, :address)
    end

    def send_notifications
      NewsletterMailer.welcome(@contact).deliver_now
      AdminMailer.newsletter_signup(@contact).deliver_now
    end
end
