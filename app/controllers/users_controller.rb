class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  skip_before_action :verify_is_admin, only: [:show, :consume]

  # PUBLIC

  # GET - the user's public profile
  def show
  end

  # POST, DELETE
  # json
  def consume
    if u = current_user
      if Store::Product::ALL_PRODUCTS.include? params[:product]
        prod = params[:product].to_sym
        u.progress_list = {}

        if request.post?
          u.progress_list[ prod ] = true
          u.save

          render json: {}, status: :created
        elsif request.delete?
          u.progress_list.delete( prod )
          u.save

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

  ### ADMIN ONLY

  def report
    @users = User.all.order('created_at DESC')
  end

  private

    def set_user
      @user = User.find( params[:id] )
    end

end
