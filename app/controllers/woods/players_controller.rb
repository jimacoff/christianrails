class Woods::PlayersController < ApplicationController
  layout "binarywoods"

  before_action :set_woods_player, only: [:show, :edit, :update, :destroy]
  before_action :verify_is_admin

  def index
    @woods_players = Woods::Player.all
  end

  def show
  end

  def new
    @woods_player = Woods::Player.new
  end

  def edit
  end

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

  def destroy
    @woods_player.destroy
    respond_to do |format|
      format.html { redirect_to woods_players_url }
      format.json { head :no_content }
    end
  end

  private
    def set_woods_player
      @woods_player = Woods::Player.find(params[:id])
    end

    def woods_player_params
      params[:woods_player]
    end
end
