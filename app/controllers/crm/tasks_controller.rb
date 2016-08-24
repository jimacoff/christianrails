class Crm::TasksController < Crm::CrmController

  before_action :set_crm_task_secure, only: [:edit, :update, :destroy, :complete, :bypass]

  before_action :set_destination, only: [:complete, :bypass]

  def index
    @tasks = Crm::Task.where(assistant_id: current_assistant.id)
                      .where(status_id: Crm::Task::STATUS_OPEN)
                      .order("due_at asc")
    @tasks ||= []
  end

  def new
    @task = Crm::Task.new
  end

  def edit
  end

  def create
    @task = Crm::Task.new(crm_task_params)
    @task.assistant = current_assistant

    respond_to do |format|
      if @task.save
        format.html { redirect_to crm_tasks_path, notice: 'Task was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @task.update(crm_task_params)
        format.html { redirect_to crm_tasks_path, notice: 'Task was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to crm_tasks_path }
    end
  end

  def closed
    @tasks = Crm::Task.where( assistant_id: current_assistant.id )
                      .where( status_id: [Crm::Task::STATUS_COMPLETE, Crm::Task::STATUS_BYPASSED] )
                      .order("closed_at desc")
    @tasks ||= []
  end

  def complete
    @task.status_id = Crm::Task::STATUS_COMPLETE
    @task.closed_at = Time.current

    respond_to do |format|

      recurral_notification = spawn_next_if_recurring

      if @task.save
        format.html { redirect_to @dest, notice: 'Task completed.' + recurral_notification }
      else
        flash[:alert] = "Could not complete this task. Please file a bug report."
        format.html { redirect_to @dest }
      end
    end
  end

  def bypass
    @task.status_id = Crm::Task::STATUS_BYPASSED
    @task.closed_at = Time.current

    recurral_notification = spawn_next_if_recurring

    respond_to do |format|
      if @task.save
        format.html { redirect_to @dest, notice: 'Task bypassed.' + recurral_notification  }
      else
        flash[:alert] = "Could not bypass this task. Please file a bug report."
        format.html { redirect_to @dest }
      end
    end
  end

  private
    def set_crm_task_secure
      @task = Crm::Task.find(params[:id])
      redirect_to(root_path) unless owns_assistant?( @task.assistant )
    end

    def crm_task_params
      params.require(:crm_task).permit(:name, :status_id, :due_at, :type_id, :recurral_period, :recurral_weekday, :notes)
    end

    # this could use some tests
    def spawn_next_if_recurring
      new_date = nil
      if @task.type_id == Crm::Task::TYPE_RECURRING_PERIOD
        new_date = @task.due_at + @task.recurral_period.days
        new_task = Crm::Task.create(name: @task.name, type_id: @task.type_id,
                                    recurral_period: @task.recurral_period,
                                    due_at: new_date )
      end

      if new_date
        current_assistant.tasks << new_task
        " Next instance scheduled for #{relative_time(new_date)}."
      else
        ""
      end
    end

    def set_destination
      @dest = params[:dest] == "home" ? crm_path : crm_tasks_path
    end

end
