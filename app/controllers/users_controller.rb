class UsersController < ApplicationController

  ### ADMIN ONLY

  def report
    @users = User.all.order('created_at DESC')
  end

end
