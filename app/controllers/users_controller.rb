class UsersController < ApplicationController

  before_action :set_user

  private

  def set_user
    @user = User.find(user_params[:id])
  end

  def user_params
    params.permit(:id)
  end

end
