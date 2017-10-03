class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  skip_before_action :verify_is_admin, only: [:show]

  # PUBLIC

  # GET - the user's public profile
  def show
  end

  ### ADMIN ONLY

  def report
    @users = User.all.order('created_at DESC')
  end

  private

    def set_user
      @user = User.find( params[:id] )
    end

end
