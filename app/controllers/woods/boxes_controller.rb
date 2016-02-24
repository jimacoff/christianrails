class Woods::BoxesController < ApplicationController
  before_action :set_woods_box, only: [:show, :edit, :update, :destroy]

  # GET /woods/boxes
  # GET /woods/boxes.json
  def index
    @woods_boxes = Woods::Box.all
  end

  # GET /woods/boxes/1
  # GET /woods/boxes/1.json
  def show
  end

  # GET /woods/boxes/new
  def new
    @woods_box = Woods::Box.new
  end

  # GET /woods/boxes/1/edit
  def edit
  end

  # POST /woods/boxes
  # POST /woods/boxes.json
  def create
    @woods_box = Woods::Box.new(woods_box_params)

    respond_to do |format|
      if @woods_box.save
        format.html { redirect_to @woods_box, notice: 'Box was successfully created.' }
        format.json { render action: 'show', status: :created, location: @woods_box }
      else
        format.html { render action: 'new' }
        format.json { render json: @woods_box.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /woods/boxes/1
  # PATCH/PUT /woods/boxes/1.json
  def update
    respond_to do |format|
      if @woods_box.update(woods_box_params)
        format.html { redirect_to @woods_box, notice: 'Box was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @woods_box.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /woods/boxes/1
  # DELETE /woods/boxes/1.json
  def destroy
    @woods_box.destroy
    respond_to do |format|
      format.html { redirect_to woods_boxes_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_woods_box
      @woods_box = Woods::Box.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def woods_box_params
      params[:woods_box]
    end
end
