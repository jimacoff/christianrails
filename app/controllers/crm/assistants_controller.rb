class Crm::AssistantsController < ApplicationController
  layout "crm"

  def index
    @assistant = current_assistant || Crm::Assistant.new

    @obligations = Crm::Obligation.where( assistant_id: current_assistant.id ).order("due_at asc") if current_assistant
    @obligations ||= []
  end

  def create
    if current_user && !current_user.assistant && current_user.has_crm_access?
      @assistant = Crm::Assistant.create( crm_assistant_params )
      current_user.assistant = @assistant
      current_user.save
    else
      @assistant = nil
    end

    respond_to do |format|
      if @assistant
        format.html { redirect_to crm_path, notice: 'Your Assistant has been created.' }
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

end
