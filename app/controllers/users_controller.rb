class UsersController < ApplicationController
  layout "binarywoods"

  before_action :set_user

  def show

  end

  def edit
    if @user == current_user

    else
      redirect_to root_path
    end
  end

  private

  def set_user
    @user = User.find(user_params[:id])
  end

  def user_params
    params.permit(:id)
  end

end
