class UsersController < ApplicationController
  before_action :set_user, only: [:show, :settings, :update]

  skip_before_action :verify_is_admin, only: [:show, :consume, :settings, :update]

  # PUBLIC

  # GET - the user's public profile
  def show
  end

  # POST, DELETE
  # json
  def consume
    if u = current_user
      if Store::Product::CHECKLIST_PRODUCTS.collect{ |x| x[:slug] }.include?( params[:product] )
        prod = params[:product].to_sym
        u.progress_list = {}

        if request.post?
          u.progress_list[ prod ] = true
          u.save

          record_event(Log::DRAWER, "#{u.fullname} checked off #{prod.to_s}.")
          render json: {}, status: :created

        elsif request.delete?
          u.progress_list.delete( prod )
          u.save

          record_event(Log::DRAWER, "#{u.fullname} unchecked #{prod.to_s}.")
          render json: {}, status: :ok

        else
          render json: {errors: "Please add or remove only."}, status: :unprocessable_entity
        end
      else
        render json: {errors: "Invalid product."}, status: :unprocessable_entity
      end
    else
      render json: {errors: "You are not logged in."}, status: :unauthorized
    end
  end

  ## USER-SPECIFIC PERMISSIONS

  def settings
    redirect_to root_path unless current_user && current_user.id == @user.id
  end

  def update
    redirect_to root_path and return unless current_user && current_user.id == @user.id

    if @user.update_attributes( user_params )
      redirect_to settings_user_path( @user ), notice: "Your settings have been updated."
    else
      flash[:alert] = "There was an error updating your settings."
      redirect_to settings_user_path( @user )
    end
  end

  ### ADMIN ONLY

  def report
    @users = User.order('created_at desc').page( params[:page] )
  end

  private

    def set_user
      @user = User.find( params[:id] )
    end

    def user_params
      params.require(:user).permit(:send_me_emails)
    end

end
