class Crm::AssistantsController < Crm::CrmController

  skip_before_action :verify_has_assistant, only: [:index, :create, :send_daily_emails]
  skip_before_action :verify_authenticity_token, only: [:send_daily_emails]

  def index
    @assistant = current_assistant || Crm::Assistant.new

    @upcoming_events = []
    @future_events = []

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
        @upcoming_events << { name: ob.name, with: ob.contact.full_name, date: ob.due_at, type: "Obligation",
                              paths:[
                                      { complete: complete_crm_obligation_path( ob ) },
                                      { bypass: bypass_crm_obligation_path( ob ) }
                                    ] }

      end
      @meetings.each do |meet|
        @upcoming_events << { name: "Meeting: " + meet.name, with: meet.contact.full_name, date: meet.date_time, type: "Meeting",
                              paths: [
                                       { complete: complete_crm_meeting_path( meet ) },
                                       { bypass: bypass_crm_meeting_path( meet ) }
                                     ] }
      end
      @tasks.each do |task|
        @upcoming_events << { name: task.name, with: "", date: task.due_at, type: "Task",
                              paths: [
                                       { complete: complete_crm_task_path( task ) },
                                       { bypass: bypass_crm_task_path( task ) }
                                     ] }
      end
      @future_events = @upcoming_events.select{ |x| x[:date] > (DateTime.current + 7.days) }
      @upcoming_events -= @future_events

      @upcoming_events.sort!{ |a, b| a[:date] <=> b[:date] }
      @future_events.sort!{ |a, b| a[:date] <=> b[:date] }


      @reading_books = Crm::Book.where(assistant_id: current_assistant.id)
                                .where(status_id: Crm::Book::STATUS_READING)
                                .order("desire_to_read desc")
    end
  end

  def create
    if current_user && !current_user.assistant && current_user.has_crm_access?
      @assistant = Crm::Assistant.create( crm_assistant_params )
      current_user.assistant = @assistant
      current_user.save
      add_initial_objects_to_crm
    else
      @assistant = nil
    end

    respond_to do |format|
      if @assistant
        format.html { redirect_to crm_path, notice: "Your Assistant #{@assistant.name} has been created!" }
      else
        flash[:alert] = "We could not create your Assistant. You may already have one."
        format.html { redirect_to crm_path }
      end
    end
  end

  def update
    @assistant = current_assistant

    respond_to do |format|
      if @assistant.update_attributes( crm_assistant_params )
        format.html { redirect_to crm_path, notice: "Your Assistant's settings have been updated!" }
      else
        flash[:alert] = "We could not update your Assistant. Please file a bug report."
        format.html { redirect_to crm_path }
      end
    end
  end

  def settings
    @assistant = current_assistant
  end

  def send_daily_emails
    Crm::Assistant.where(email_me_daily: true).each do |assistant|
      if assistant.ripe_for_email?
        send_daily_summary( assistant )
      end
    end

    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private

    def crm_assistant_params
      params.require(:crm_assistant).permit(:name, :personality_id, :email_me_daily, :time_zone)
    end

    def send_daily_summary(assistant)
      Crm::ReminderMailer.daily_summary( assistant ).deliver_now
      create_new_mailout_record( assistant, Crm::Mailout::TYPE_DAILY_SUMMARY )
    end

    def create_new_mailout_record(assistant, type)
      Crm::Mailout.create(assistant_id: assistant.id, type_id: type, status_id: Crm::Mailout::STATUS_COMPLETE)
    end

    def add_initial_objects_to_crm
      @book = Crm::Book.create(title: "Ghostcrime", author: "Christian DeWolf")
      @book.assistant = @assistant
      @book.save

      task = Crm::Task.create(name: "Start organizing your life",
                              due_at: DateTime.now,
                              notes: "Yeah it's a complete mess right now" )
      task.assistant = @assistant
      task.save
    end

end
