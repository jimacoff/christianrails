class Woods::FootprintsController < ApplicationController
  layout "binarywoods"

  before_action :set_woods_footprint, only: [:show, :edit, :update, :destroy]
  before_action :verify_is_admin

  # GET /woods/footprints
  # GET /woods/footprints.json
  def index
    @footprints = Woods::Footprint.all
  end

  # GET /woods/footprints/1
  # GET /woods/footprints/1.json
  def show
  end

  # GET /woods/footprints/new
  def new
    @footprint = Woods::Footprint.new
  end

  # GET /woods/footprints/1/edit
  def edit
  end

  # POST /woods/footprints
  # POST /woods/footprints.json
  def create
    @footprint = Woods::Footprint.new(woods_footprint_params)

    respond_to do |format|
      if @footprint.save
        format.html { redirect_to @footprint, notice: 'Footprint was successfully created.' }
        format.json { render action: 'show', status: :created, location: @footprint }
      else
        format.html { render action: 'new' }
        format.json { render json: @footprint.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /woods/footprints/1
  # PATCH/PUT /woods/footprints/1.json
  def update
    respond_to do |format|
      if @footprint.update(woods_footprint_params)
        format.html { redirect_to @footprint, notice: 'Footprint was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @footprint.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /woods/footprints/1
  # DELETE /woods/footprints/1.json
  def destroy
    @footprint.destroy
    respond_to do |format|
      format.html { redirect_to woods_footprints_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_woods_footprint
      @footprint = Woods::Footprint.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def woods_footprint_params
      params[:woods_footprint]
    end
end
