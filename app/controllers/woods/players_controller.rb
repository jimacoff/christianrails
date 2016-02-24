class Woods::PlayersController < ApplicationController
  before_action :set_woods_player, only: [:show, :edit, :update, :destroy]

  # GET /woods/players
  # GET /woods/players.json
  def index
    @woods_players = Woods::Player.all
  end

  # GET /woods/players/1
  # GET /woods/players/1.json
  def show
  end

  # GET /woods/players/new
  def new
    @woods_player = Woods::Player.new
  end

  # GET /woods/players/1/edit
  def edit
  end

  # POST /woods/players
  # POST /woods/players.json
  def create
    @woods_player = Woods::Player.new(woods_player_params)

    respond_to do |format|
      if @woods_player.save
        format.html { redirect_to @woods_player, notice: 'Player was successfully created.' }
        format.json { render action: 'show', status: :created, location: @woods_player }
      else
        format.html { render action: 'new' }
        format.json { render json: @woods_player.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /woods/players/1
  # PATCH/PUT /woods/players/1.json
  def update
    respond_to do |format|
      if @woods_player.update(woods_player_params)
        format.html { redirect_to @woods_player, notice: 'Player was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @woods_player.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /woods/players/1
  # DELETE /woods/players/1.json
  def destroy
    @woods_player.destroy
    respond_to do |format|
      format.html { redirect_to woods_players_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_woods_player
      @woods_player = Woods::Player.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def woods_player_params
      params[:woods_player]
    end
end
