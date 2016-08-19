class Crm::ObligationsController < Crm::CrmController

  before_action :set_crm_obligation_secure, only: [:edit, :update, :destroy, :complete, :bypass]
  before_action :get_contacts, only: [:index, :new, :edit]

  before_action :set_destination, only: [:complete, :bypass]

  def index
    @obligations = Crm::Obligation.where(assistant_id: current_assistant.id)
                                  .where(status_id: Crm::Obligation::STATUS_OPEN)
                                  .order("due_at asc")
    @obligations ||= []
  end

  def new
    @obligation = Crm::Obligation.new
  end

  def edit
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

  def closed
    @obligations = Crm::Obligation.where( assistant_id: current_assistant.id )
                                  .where(status_id: [Crm::Obligation::STATUS_COMPLETE, Crm::Obligation::STATUS_BYPASSED] )
                                  .order("closed_at desc")
    @obligations ||= []
  end

  def complete
    @obligation.status_id = Crm::Obligation::STATUS_COMPLETE
    @obligation.closed_at = Time.now

    respond_to do |format|
      if @obligation.save
        format.html { redirect_to @dest, notice: 'Obligation completed.' }
      else
        flash[:alert] = "Could not complete this obligation. Please file a bug report."
        format.html { redirect_to @dest }
      end
    end
  end

  def bypass
    @obligation.status_id = Crm::Obligation::STATUS_BYPASSED
    @obligation.closed_at = Time.now

    respond_to do |format|
      if @obligation.save
        format.html { redirect_to @dest, notice: 'Obligation bypassed.' }
      else
        flash[:alert] = "Could not bypass this obligation. Please file a bug report."
        format.html { redirect_to @dest }
      end
    end
  end

  private
    def set_crm_obligation_secure
      @obligation = Crm::Obligation.find(params[:id])
      redirect_to(root_path) unless owns_assistant?( @obligation.assistant )
    end

    def crm_obligation_params
      params.require(:crm_obligation).permit(:contact_id, :name, :status_id, :due_at, :notes)
    end

    def get_contacts
      @contacts = Crm::Contact.where(assistant_id: current_assistant.id)
    end

    def verify_contact
      redirect_to(root_path) and return unless owns_assistant?( @contact.assistant )
      true
    end

    def set_destination
      @dest = params[:dest] == "home" ? crm_path : crm_obligations_path
    end
end
