class Crm::IdeasController < Crm::CrmController

  before_action :set_crm_idea_secure, only: [:edit, :update, :destroy, :complete, :abandon ]

  ## LOGGED-IN ASSISTANTS ONLY

  def index
    @ideas = Crm::Idea.where(assistant_id: current_assistant.id)
                      .where(status_id: Crm::Idea::STATUS_OPEN)
                      .order("created_at desc")
    @ideas ||= []
  end

  def new
    @idea = Crm::Idea.new
  end

  def edit
  end

  def create
    @idea = Crm::Idea.new(crm_idea_params)
    @idea.assistant = current_assistant

    respond_to do |format|
      if @idea.save
        format.html { redirect_to crm_ideas_path, notice: 'Idea was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @idea.update(crm_idea_params)
        format.html { redirect_to crm_ideas_path, notice: 'Idea was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @idea.destroy
    respond_to do |format|
      format.html { render action: 'index' }
    end
  end

  def closed
    @ideas = Crm::Idea.where( assistant_id: current_assistant.id )
                      .where( status_id: [Crm::Idea::STATUS_COMPLETE, Crm::Idea::STATUS_ABANDONED] )
                      .order("completed_on desc")
    @ideas ||= []
  end

  def complete
    @idea.status_id = Crm::Idea::STATUS_COMPLETE
    @idea.completed_on = Time.current

    respond_to do |format|
      if @idea.save
        format.html { redirect_to crm_ideas_path, notice: "Idea complete!" }
      else
        flash[:alert] = "Could not complete this idea. Please file a bug report."
        format.html { redirect_to crm_ideas_path }
      end
    end
  end

  def abandon
    @idea.status_id = Crm::Idea::STATUS_ABANDONED
    @idea.completed_on = Time.current

    respond_to do |format|
      if @idea.save
        format.html { redirect_to crm_ideas_path, notice: 'Idea abandoned!' }
      else
        flash[:alert] = "Could not abandon this idea! Please file a bug report. Or maybe this is a sign."
        format.html { redirect_to crm_ideas_path }
      end
    end
  end

  private
    def set_crm_idea_secure
      @idea = Crm::Idea.find(params[:id])
      redirect_to(root_path) unless owns_assistant?( @idea.assistant )
    end

    def crm_idea_params
      params.require(:crm_idea).permit(:name, :notes)
    end
end
