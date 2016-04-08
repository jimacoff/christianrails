class Woods::PlayersController < ApplicationController
  layout "binarywoods"

  before_action :set_woods_player, only: [:show]
  skip_before_action :verify_is_admin, only: [:show]

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
