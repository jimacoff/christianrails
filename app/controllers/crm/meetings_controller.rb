class Crm::MeetingsController < ApplicationController
  layout "crm"

  before_action :set_crm_meeting_secure, only: [:edit, :update, :destroy]
  before_action :verify_has_assistant, except: [:newsletter_signup]

  def index
    @meetings = Crm::Meeting.order("date_time asc")
    @meetings ||= []
  end

  def new
    @meeting = Crm::Meeting.new
    get_contacts
  end

  def edit
    get_contacts
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

  private
    def set_crm_meeting_secure
      @meeting = Crm::Meeting.find(params[:id])
      redirect_to(root_path) unless owns_assistant?( @meeting.assistant )
    end

    def crm_meeting_params
      params.require(:crm_meeting).permit(:contact_id, :name, :status_id, :date_time)
    end

    def get_contacts
      @contacts = Crm::Contact.where(assistant_id: current_assistant.id)
    end

    def verify_contact
      redirect_to(root_path) and return unless owns_assistant?( @contact.assistant )
      true
    end
end
