class MelonController < ApplicationController

  layout "melon"

  skip_before_action :verify_is_admin, only: [:index, :create]

  ## PUBLIC

  def index
  end

  def create
    @melon = Melon.new(melon_params)
    if @melon.save
      record_positive_event(Log::MELON, "Someone clicked on the #{ Melon::TYPE_NAMES[ @melon.type_id ] } melon!")
      render json: {melonType: @melon.type_id}, status: :created
    else
      render json: {errors: @melon.errors}, status: :unprocessable_entity
    end
  end

  ## ADMIN ONLY

  def stats
    @orange_melons = Melon.where(type_id: Melon::TYPE_ORANGE).size
    @yellow_melons = Melon.where(type_id: Melon::TYPE_YELLOW).size
    @green_melons  = Melon.where(type_id: Melon::TYPE_GREEN).size
  end

  private

    def melon_params
      params.require(:melon).permit(:type_id)
    end

end
