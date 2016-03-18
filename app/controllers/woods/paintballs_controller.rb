class Woods::PaintballsController < ApplicationController
  layout "binarywoods"

  before_action :set_woods_paintball, only: [:show, :edit, :update, :destroy]
  before_action :verify_is_admin

  # POST /woods/paintballs
  # POST /woods/paintballs.json
  def create
    @paintball = Woods::Paintball.new(woods_paintball_params)

    respond_to do |format|
      if @paintball.save
        format.html { redirect_to @paintball, notice: 'Paintball was successfully created.' }
        format.json { render action: 'show', status: :created, location: @paintball }
      else
        format.html { render action: 'new' }
        format.json { render json: @paintball.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /woods/paintballs/1
  # PATCH/PUT /woods/paintballs/1.json
  def update
    respond_to do |format|
      if @paintball.update(woods_paintball_params)
        format.html { redirect_to @paintball, notice: 'Paintball was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @paintball.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_woods_paintball
      @paintball = Woods::Paintball.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def woods_paintball_params
      params[:woods_paintball]
    end
end
