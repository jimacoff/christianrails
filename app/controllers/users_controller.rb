class UsersController < ApplicationController
  layout "binarywoods"

  before_action :set_user
  skip_before_action :verify_is_admin

  def show
  end

  private

  def set_user
    @user = User.find(user_params[:id])
  end

  def user_params
    params.permit(:id)
  end

end
