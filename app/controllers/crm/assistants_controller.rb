class Crm::AssistantsController < ApplicationController
  layout "crm"

  def index
    @assistant = current_assistant || Crm::Assistant.new

    @upcoming_events = []

    if current_assistant
      @obligations = Crm::Obligation.where( assistant_id: current_assistant.id )
                                    .where(status_id: Crm::Obligation::STATUS_OPEN)
                                    .order("due_at asc")
      @meetings = Crm::Meeting.where( assistant_id: current_assistant.id )
                              .where(status_id: Crm::Meeting::STATUS_FORTHCOMING)
                              .order("date_time asc")
      @tasks = Crm::Task.where( assistant_id: current_assistant.id )
                        .where(status_id: Crm::Task::STATUS_OPEN)
                        .order("due_at asc")

      # do this more functionally
      @obligations.each do |ob|
        @upcoming_events << { name: ob.name, with: ob.contact.full_name, date: ob.due_at,
                              paths:[
                                      { complete: complete_crm_obligation_path( ob ) },
                                      { bypass: bypass_crm_obligation_path( ob ) }
                                    ] }

      end
      @meetings.each do |meet|
        @upcoming_events << { name: "Meeting: " + meet.name, with: meet.contact.full_name, date: meet.date_time,
                              paths: [
                                       { complete: complete_crm_meeting_path( meet ) },
                                       { bypass: bypass_crm_meeting_path( meet ) }
                                     ] }
      end
      @tasks.each do |task|
        @upcoming_events << { name: task.name, with: "", date: task.due_at,
                              paths: [
                                       { complete: complete_crm_task_path( task ) },
                                       { bypass: bypass_crm_task_path( task ) }
                                     ] }
      end

      @upcoming_events.sort!{ |a, b| a[:date] <=> b[:date] }
    end
  end

  def reminders
    # TODO
  end

  def create
    if current_user && !current_user.assistant && current_user.has_crm_access?
      @assistant = Crm::Assistant.create( crm_assistant_params )
      current_user.assistant = @assistant
      current_user.save
      add_ghostcrime_to_crm
    else
      @assistant = nil
    end

    respond_to do |format|
      if @assistant
        format.html { redirect_to crm_path, notice: "Your Assistant #{@assistant.name} has been created!" }
      else
        flash[:alert] = "We could not create your Assistant. You may already have one."
        format.html { render action: 'index' }
      end
    end
  end

  private

    def set_crm_assistant
      @assistant = Crm::Assistant.find(params[:id])
    end

    def crm_assistant_params
      params.require(:crm_assistant).permit(:name, :personality_id)
    end

    def send_notifications
      NewsletterMailer.welcome(@assistant).deliver_now
      AdminMailer.newsletter_signup(@assistant).deliver_now
    end

    def add_ghostcrime_to_crm
      @book = Crm::Book.create(title: "Ghostcrime", author: "Christian DeWolf")
      @book.assistant = @assistant
      @book.save
    end

end
