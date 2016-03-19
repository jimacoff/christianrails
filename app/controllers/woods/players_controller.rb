class Woods::PlayersController < ApplicationController
  layout "binarywoods"

  before_action :set_woods_player, only: [:show, :edit, :update, :destroy]
  before_action :verify_is_admin

  def index
    @players = Woods::Player.all
  end

  def show
  end

  private
    def set_woods_player
      @player = Woods::Player.find(params[:id])
    end

    def woods_player_params
      params[:woods_player]
    end
end
