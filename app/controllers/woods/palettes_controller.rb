class Woods::PalettesController < ApplicationController
  layout "binarywoods"

  before_action :set_woods_palette, only: [:show, :edit, :update, :destroy]

  # GET /woods/palettes
  # GET /woods/palettes.json
  def index
    @palettes = Woods::Palette.all
  end

  # GET /woods/palettes/1
  # GET /woods/palettes/1.json
  def show
  end

  # GET /woods/palettes/new
  def new
    @palette = Woods::Palette.new
  end

  # GET /woods/palettes/1/edit
  def edit
  end

  # POST /woods/palettes
  # POST /woods/palettes.json
  def create
    @palette = Woods::Palette.new(woods_palette_params)

    respond_to do |format|
      if @palette.save
        format.html { redirect_to @palette, notice: 'Palette was successfully created.' }
        format.json { render action: 'show', status: :created, location: @palette }
      else
        format.html { render action: 'new' }
        format.json { render json: @palette.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /woods/palettes/1
  # PATCH/PUT /woods/palettes/1.json
  def update
    respond_to do |format|
      if @palette.update(woods_palette_params)
        format.html { redirect_to @palette, notice: 'Palette was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @palette.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /woods/palettes/1
  # DELETE /woods/palettes/1.json
  def destroy
    @palette.destroy
    respond_to do |format|
      format.html { redirect_to woods_palettes_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_woods_palette
      @palette = Woods::Palette.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def woods_palette_params
      params[:woods_palette]
    end
end
