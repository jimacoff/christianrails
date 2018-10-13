class Woods::PlayersController < Woods::WoodsController

  skip_before_action :verify_is_admin, only: [:show]

  ## PUBLIC

  # shows the player's public 'profile' + stats + finds
  def show
    @player = Woods::Player.find( woods_player_params[:id] )

    @finds_by_story = {}
    @player.finds.each do |find|
      @finds_by_story[find.story] = [] if !@finds_by_story[find.story]
      @finds_by_story[find.story] << find
    end
  end

  ## ADMIN ONLY

  def index
    @players = Woods::Player.all
  end

  private

    def woods_player_params
      params.permit(:id)
    end

end
