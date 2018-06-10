class MelonController < ApplicationController

  layout "melon"

  skip_before_action :verify_is_admin

  ## PUBLIC

  def index
  end

  def create
    @melon = Melon.new(melon_params)
    if @melon.save
      render json: {melonType: @melon.type_id}, status: :created
    else
      render json: {errors: @melon.errors}, status: :unprocessable_entity
    end
  end

  private

    def melon_params
      params.require(:melon).permit(:type_id)
    end

end
