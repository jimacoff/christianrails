class Woods::PlayersController < ApplicationController
  layout "binarywoods"

  before_action :set_woods_player, only: [:show, :edit, :update, :destroy]
  before_action :verify_is_admin

  def index
    @players = Woods::Player.all
  end

  def show
  end

  def new
    @player = Woods::Player.new
  end

  def edit
  end

  def create
    @player = Woods::Player.new(woods_player_params)

    respond_to do |format|
      if @player.save
        format.html { redirect_to @player, notice: 'Player was successfully created.' }
        format.json { render action: 'show', status: :created, location: @player }
      else
        format.html { render action: 'new' }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @player.update(woods_player_params)
        format.html { redirect_to @player, notice: 'Player was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @player.destroy
    respond_to do |format|
      format.html { redirect_to woods_players_url }
      format.json { head :no_content }
    end
  end

  private
    def set_woods_player
      @player = Woods::Player.find(params[:id])
    end

    def woods_player_params
      params[:woods_player]
    end
end
