class Crm::TasksController < ApplicationController
  layout "crm"

  before_action :set_crm_task_secure, only: [:edit, :update, :destroy, :complete, :bypass]
  before_action :verify_has_assistant

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
      format.html { render action: 'index' }
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
    @task.closed_at = Time.now

    respond_to do |format|

      # TODO recurral notification

      if @task.save
        format.html { redirect_to crm_tasks_path, notice: 'Task completed.' }
      else
        flash[:alert] = "Could not complete this task. Check with the programmer."
        format.html { redirect_to crm_tasks_path }
      end
    end
  end

  def bypass
    @task.status_id = Crm::Task::STATUS_BYPASSED
    @task.closed_at = Time.now

    respond_to do |format|
      if @task.save
        format.html { redirect_to crm_tasks_path, notice: 'Task bypassed.' }
      else
        flash[:alert] = "Could not bypass this task. Check with the programmer."
        format.html { redirect_to crm_tasks_path }
      end
    end
  end

  private
    def set_crm_task_secure
      @task = Crm::Task.find(params[:id])
      redirect_to(root_path) unless owns_assistant?( @task.assistant )
    end

    def crm_task_params
      params.require(:crm_task).permit(:name, :status_id, :due_at, :type_id, :recurral_period, :recurral_weekday, :recurral_monthday)
    end
end
