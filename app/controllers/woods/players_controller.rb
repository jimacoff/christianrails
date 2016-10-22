class Woods::PlayersController < Woods::WoodsController

  skip_before_action :verify_is_admin, only: [:show]

  def index
    @players = Woods::Player.all
  end

  def show
    # shows the player's 'profile' + stats + finds
    @player = Woods::Player.find( woods_player_params[:id] )
  end

  private
    def woods_player_params
      params.permit(:id)
    end
end
