class NuggetsController < ApplicationController

  layout 'comedygold'

  skip_before_action :verify_is_admin

  ## PUBLIC

  def index
    @nuggets = Nugget.order('serial_number asc')
  end

  ## LOGGED-IN ONLY

  # POST - attempts to unlock a nugget
  def unlock
    if current_user
      if params[:access_code] && !params[:access_code].empty?
        if nugget = Nugget.where(access_code: params[:access_code]).take
          nugget.unlocked_by = current_user
          nugget.unlocked_at = DateTime.current
          nugget.save

          record_positive_event(Log::STORE, "ComedyGold joke unlocked! #{ nugget.joke }")
          flash[:notice] = "Joke magnetically unlocked!"
        else
          flash[:alert] = "Invalid code. Please check your magnetic reader and try again."
        end
      else
        flash[:alert] = "Please provide an access code."
      end
    else
      flash[:alert] = "Please log in to unlock a joke."
    end
    redirect_to comedygold_path
  end

end
