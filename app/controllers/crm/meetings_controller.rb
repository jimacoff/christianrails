class Crm::MeetingsController < Crm::CrmController

  before_action :set_crm_meeting_secure, only: [:edit, :update, :destroy, :complete, :bypass]
  before_action :get_contacts, only: [:index, :new, :edit]
  before_action :set_destination, only: [:complete, :bypass]

  ## LOGGED-IN ASSISTANTS ONLY

  def index
    @meetings = Crm::Meeting.where(assistant_id: current_assistant.id)
                            .where(status_id: Crm::Meeting::STATUS_FORTHCOMING)
                            .order("date_time asc")
    @meetings ||= []
  end

  def new
    @meeting = Crm::Meeting.new
  end

  def edit
  end

  def create
    @meeting = Crm::Meeting.new(crm_meeting_params)

    @contact = Crm::Contact.find( crm_meeting_params[:contact_id] )
    verify_contact

    @meeting.assistant = current_assistant

    respond_to do |format|
      if @meeting.save
        format.html { redirect_to crm_meetings_path, notice: 'Meeting was successfully created.' }
      else
        get_contacts
        format.html { render action: 'new' }
      end
    end
  end

  def update
    @contact = Crm::Contact.find( crm_meeting_params[:contact_id] )
    verify_contact

    respond_to do |format|
      if @meeting.update(crm_meeting_params)
        format.html { redirect_to crm_meetings_path, notice: 'Meeting was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @meeting.destroy
    respond_to do |format|
      format.html { render action: 'index' }
    end
  end

  def past
    @meetings = Crm::Meeting.where( assistant_id: current_assistant.id )
                            .where( status_id: [Crm::Meeting::STATUS_COMPLETE, Crm::Meeting::STATUS_BYPASSED] )
                            .order("closed_at desc")
    @meetings ||= []
  end

  def complete
    @meeting.status_id = Crm::Meeting::STATUS_COMPLETE
    @meeting.closed_at = Time.current

    respond_to do |format|

      if @meeting.save
        format.html { redirect_to @dest, notice: 'Meeting completed.' }
      else
        flash[:alert] = "Could not complete this meeting. Please file a bug report."
        format.html { redirect_to @dest }
      end
    end
  end

  def bypass
    @meeting.status_id = Crm::Meeting::STATUS_BYPASSED
    @meeting.closed_at = Time.current

    respond_to do |format|
      if @meeting.save
        format.html { redirect_to @dest, notice: 'Meeting bypassed.' }
      else
        flash[:alert] = "Could not bypass this meeting. Please file a bug report."
        format.html { redirect_to @dest }
      end
    end
  end

  private
    def set_crm_meeting_secure
      @meeting = Crm::Meeting.find(params[:id])
      redirect_to(root_path) unless owns_assistant?( @meeting.assistant )
    end

    def crm_meeting_params
      params.require(:crm_meeting).permit(:contact_id, :name, :date_time, :location, :agenda, :notes, :time)
    end

    def get_contacts
      @contacts = Crm::Contact.where(assistant_id: current_assistant.id)
    end

    def verify_contact
      redirect_to(root_path) and return unless owns_assistant?( @contact.assistant )
    end

    def set_destination
      @dest = params[:dest] == "home" ? crm_path : crm_meetings_path
    end

end
