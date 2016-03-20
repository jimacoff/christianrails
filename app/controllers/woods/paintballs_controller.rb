class Woods::PaintballsController < ApplicationController
  layout "binarywoods"

  before_action :set_woods_paintball, only: [:update]
  before_action :verify_is_admin

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
    def set_woods_paintball
      @paintball = Woods::Paintball.find(params[:id])
    end

    def woods_paintball_params
      params[:woods_paintball]
    end
end
