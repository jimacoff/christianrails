class Woods::PossibleitemsController < ApplicationController
  layout "binarywoods"

  before_action :set_woods_possibleitem, only: [:show, :edit, :update, :destroy]

  # GET /woods/possibleitems
  # GET /woods/possibleitems.json
  def index
    @woods_possibleitems = Woods::Possibleitem.all
  end

  # GET /woods/possibleitems/1
  # GET /woods/possibleitems/1.json
  def show
  end

  # GET /woods/possibleitems/new
  def new
    @woods_possibleitem = Woods::Possibleitem.new
  end

  # GET /woods/possibleitems/1/edit
  def edit
  end

  # POST /woods/possibleitems
  # POST /woods/possibleitems.json
  def create
    @woods_possibleitem = Woods::Possibleitem.new(woods_possibleitem_params)

    respond_to do |format|
      if @woods_possibleitem.save
        format.html { redirect_to @woods_possibleitem, notice: 'Possibleitem was successfully created.' }
        format.json { render action: 'show', status: :created, location: @woods_possibleitem }
      else
        format.html { render action: 'new' }
        format.json { render json: @woods_possibleitem.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /woods/possibleitems/1
  # PATCH/PUT /woods/possibleitems/1.json
  def update
    respond_to do |format|
      if @woods_possibleitem.update(woods_possibleitem_params)
        format.html { redirect_to @woods_possibleitem, notice: 'Possibleitem was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @woods_possibleitem.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /woods/possibleitems/1
  # DELETE /woods/possibleitems/1.json
  def destroy
    @woods_possibleitem.destroy
    respond_to do |format|
      format.html { redirect_to woods_possibleitems_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_woods_possibleitem
      @woods_possibleitem = Woods::Possibleitem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def woods_possibleitem_params
      params[:woods_possibleitem]
    end
end
